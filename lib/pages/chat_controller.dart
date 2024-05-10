import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get_storage/get_storage.dart';

class ChatController extends GetxController {
  final storage = GetStorage();
  final apiKey = ''.obs;
  late final OpenAI _openAI;

  final ChatUser currentUser = ChatUser(id: '1', firstName: 'John', lastName: 'Doe');
  final ChatUser gptChatUser = ChatUser(id: '2', firstName: 'Chat', lastName: 'GPT');

  var messages = <ChatMessage>[].obs;
  var typingUsers = <ChatUser>[].obs;

  final TextEditingController textController = TextEditingController();
  final SpeechToText speechToText = SpeechToText();

  var speechEnabled = false.obs;
  var wordsSpoken = "".obs;
  var confidenceLevel = 0.0.obs;
  var isListening = false.obs;

  @override
  void onInit() {
    super.onInit();

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
      autoSendMessage();
    }
    update();
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

  void showBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          widthFactor: 1,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                ),
                Obx(() => SizedBox(
                      width: 200,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isListening.value ? Icons.mic : Icons.mic_off,
                              color: const Color(0xFF00A67E),
                              size: 32,
                            ),
                            color: const Color(0xFF00A67E),
                            onPressed: () {
                              if (isListening.value) {
                                stopListening();
                              } else {
                                startListening();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Color(0xFF00A67E),
                              size: 32,
                            ),
                            color: const Color(0xFF00A67E),
                            onPressed: () {
                              clearListening();
                            },
                          ),
                        ],
                      ),
                    )),
                Obx(
                  () => Text(
                    isListening.value
                        ? "Listening..."
                        : speechEnabled.value
                            ? "Tap the microphone to start listening..."
                            : "Speech not available",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Obx(
                  () => Text(
                    wordsSpoken.value,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: speechToText.isNotListening && confidenceLevel.value > 0,
                    child: Text(
                      "Confidence: ${(confidenceLevel.value * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
