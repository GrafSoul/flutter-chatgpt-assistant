import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get_storage/get_storage.dart';

class ChatController extends GetxController with GetSingleTickerProviderStateMixin {
  final storage = GetStorage();
  final apiKey = ''.obs;
  late final OpenAI _openAI;

  final ChatUser currentUser = ChatUser(id: '1', firstName: 'John', lastName: 'Doe');
  final ChatUser gptChatUser = ChatUser(id: '2', firstName: 'Chat', lastName: 'GPT');

  var messages = <ChatMessage>[].obs;
  var typingUsers = <ChatUser>[].obs;

  late AnimationController animationController;
  late Animation<double> opacityAnimation;

  final TextEditingController textController = TextEditingController();
  final SpeechToText speechToText = SpeechToText();

  var speechEnabled = false.obs;
  var wordsSpoken = "".obs;
  var confidenceLevel = 0.0.obs;
  var isListening = false.obs;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    opacityAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(animationController);

    initSpeech();

    apiKey.value = storage.read('apiKey') ?? '';

    if (apiKey.value.isNotEmpty) {
      _openAI = OpenAI.instance.build(
        token: apiKey.value,
        baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 5),
        ),
        enableLog: true,
      );
    }
  }

  @override
  void onClose() {
    super.onClose();
    // Dispose animation controller
    animationController.dispose();
    textController.dispose();
  }

  void saveApiKey(String key) {
    apiKey.value = key;
    storage.write('apiKey', key.toString());
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
    textController.text = '';
    wordsSpoken.value = '';

    update();
  }

  void autoSendMessage() async {
    final ChatMessage message = ChatMessage(
      text: textController.text,
      user: currentUser,
      createdAt: DateTime.now(),
    );

    await sendMessage(message);
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
    animationController.repeat(reverse: true);
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
    animationController.stop();
    if (isListening.value) {
      await speechToText.stop();
      isListening.value = false;
      speechEnabled.value = false;
      autoSendMessage();
    }
    update();
  }

  void toggleListening() {
    if (isListening.value) {
      stopListening();
    } else {
      startListening();
    }
  }

  void clearListening() async {
    if (isListening.value) {
      await speechToText.stop();
      isListening.value = false;
      speechEnabled.value = false;
    }
    textController.text = '';
    wordsSpoken.value = '';
    confidenceLevel.value = 0;
    update();
  }

  void onSpeechResult(result) {
    wordsSpoken.value = result.recognizedWords;
    confidenceLevel.value = result.confidence;

    textController.text = result.recognizedWords;
    wordsSpoken.value = result.recognizedWords;
    update();
  }

  Animation<double> getOpacityAnimation() {
    return opacityAnimation;
  }
}
