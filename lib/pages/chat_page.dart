import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'chat_controller.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 166, 126, 1),
        title: const Text(
          'ChatGPT Assistant',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // Use the controller's animation to make the mic blink
          AnimatedBuilder(
            animation: chatController.getOpacityAnimation(),
            builder: (context, child) {
              return Opacity(
                opacity: chatController.isListening.value ? chatController.getOpacityAnimation().value : 1.0,
                child: Obx(() => IconButton(
                      icon: Icon(
                        chatController.isListening.value ? Icons.mic : Icons.mic_off,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: chatController.toggleListening,
                    )),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.vpn_key_outlined, color: Colors.white),
          onPressed: () {
            Get.defaultDialog(
              title: 'Enter API Key',
              content: ApiKeyInputDialog(chatController),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => DashChat(
                currentUser: chatController.currentUser,
                messages: chatController.messages.toList(),
                onSend: (ChatMessage m) => chatController.sendMessage(m),
                messageOptions: const MessageOptions(
                  currentUserContainerColor: Colors.black,
                  containerColor: Color.fromRGBO(0, 166, 126, 1),
                  textColor: Colors.white,
                ),
                inputOptions: InputOptions(
                  textController: chatController.textController,
                  alwaysShowSend: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ApiKeyInputDialog extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

  final TextEditingController textController;

  ApiKeyInputDialog(chatController, {super.key})
      : textController = TextEditingController(text: chatController.apiKey.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: textController,
          decoration: const InputDecoration(labelText: 'API Key'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            chatController.saveApiKey(textController.text);
            Get.back();
          },
          child: const Text('Save'),
        )
      ],
    );
  }
}
