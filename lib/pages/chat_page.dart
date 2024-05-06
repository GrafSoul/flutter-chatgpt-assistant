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
          IconButton(
            icon: Obx(() => Icon(
                  chatController.isListening.value ? Icons.mic : Icons.mic_off,
                  color: Colors.white,
                )),
            color: Colors.white,
            onPressed: () {
              if (chatController.isListening.value) {
                chatController.stopListening();
              } else {
                chatController.startListening();
              }
            },
          ),
        ],
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
