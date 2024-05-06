import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatController extends GetxController {
  late final String apiKey;
  late final OpenAI _openAI;

  final ChatUser currentUser = ChatUser(id: '1', firstName: 'John', lastName: 'Doe');
  final ChatUser gptChatUser = ChatUser(id: '2', firstName: 'Chat', lastName: 'GPT');

  var messages = <ChatMessage>[].obs;
  var typingUsers = <ChatUser>[].obs;

  final SpeechToText speechToText = SpeechToText();

  var speechEnabled = false.obs;
  var wordsSpoken = "".obs;
  var confidenceLevel = 0.0.obs;
  var isListening = false.obs;

  @override
  void onInit() {
    super.onInit();

    initSpeech();

    apiKey = dotenv.get('API_OPENAI_KEY', fallback: 'Unknown');
    _openAI = OpenAI.instance.build(
      token: apiKey,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 5),
      ),
      enableLog: true,
    );
  }

  Future<void> sendMessage(ChatMessage m) async {
    messages.insert(0, m);
    typingUsers.add(gptChatUser);

    List<Messages> messagesHistory = messages.reversed.map((m) {
      if (m.user == currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();

    String getRoleString(Role role) {
      switch (role) {
        case Role.user:
          return 'user';
        case Role.assistant:
          return 'assistant';
        default:
          return 'user';
      }
    }

    List<Map<String, dynamic>> messagesAsMaps = messagesHistory.map((message) {
      return {'role': getRoleString(message.role), 'content': message.content};
    }).toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: messagesAsMaps,
      maxToken: 200,
    );

    final response = await _openAI.onChatCompletion(request: request);

    for (var element in response!.choices) {
      if (element.message != null) {
        messages.insert(
          0,
          ChatMessage(user: gptChatUser, createdAt: DateTime.now(), text: element.message!.content),
        );
      }
    }

    typingUsers.remove(gptChatUser);
    wordsSpoken.value = '';
  }

  void onStatusChanged(String status) {
    isListening.value = status == 'listening';
    speechEnabled.value = speechToText.isAvailable;
    update();
  }

  void initSpeech() async {
    speechEnabled.value = await speechToText.initialize();
  }

  void startListening() async {
    if (!isListening.value) {
      isListening.value = true;
      await speechToText.listen(
        onResult: onSpeechResult,
        localeId: 'ru_RU',
      );
      confidenceLevel.value = 0;
    }
    update();
  }

  void stopListening() async {
    if (isListening.value) {
      await speechToText.stop();
      isListening.value = false;
      speechEnabled.value = false;
    }
    update();
  }

  void onSpeechResult(result) {
    wordsSpoken.value = result.recognizedWords;
    confidenceLevel.value = result.confidence;
  }
}
