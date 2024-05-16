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
          'Assistant',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.vpn_key_outlined, color: Colors.white),
            onPressed: () {
              Get.defaultDialog(
                title: 'Enter API Key',
                content: ApiKeyInputDialog(chatController),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Get.toNamed('/profile');
            },
          ),
          Obx(() {
            if (chatController.userData['role'] == 'admin') {
              return IconButton(
                icon: const Icon(Icons.people, color: Colors.white),
                onPressed: () {
                  Get.toNamed('/users');
                },
              );
            }
            return const SizedBox.shrink();
          }),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              chatController.logOut();
            },
          )
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
                messageOptions: MessageOptions(
                  currentUserContainerColor: Colors.black,
                  containerColor: const Color.fromRGBO(0, 166, 126, 1),
                  textColor: Colors.white,
                  avatarBuilder: (chatUser, onPress, onLongPress) => GestureDetector(
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                        child: Image.asset(
                          chatUser.profileImage!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                inputOptions: InputOptions(
                  sendButtonBuilder: (Function onSend) {
                    return IconButton(
                      icon: const Icon(Icons.send, size: 36, color: Color.fromRGBO(0, 166, 126, 1)),
                      onPressed: () {
                        onSend();
                      },
                    );
                  },
                  inputToolbarPadding: const EdgeInsets.only(left: 72, bottom: 18),
                  textController: chatController.textController,
                  cursorStyle: const CursorStyle(
                    color: Color.fromRGBO(0, 166, 126, 1),
                  ),
                  alwaysShowSend: true,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: chatController.getOpacityAnimation(),
        builder: (context, child) {
          return Opacity(
            opacity: chatController.isListening.value ? chatController.getOpacityAnimation().value : 1.0,
            child: Obx(() => FloatingActionButton(
                  onPressed: chatController.toggleListening,
                  backgroundColor: chatController.isListening.value
                      ? const Color.fromARGB(255, 166, 0, 0)
                      : const Color.fromRGBO(0, 166, 126, 1),
                  elevation: 0,
                  mini: true,
                  child: Icon(
                    chatController.isListening.value ? Icons.mic : Icons.mic_off,
                    color: Colors.white,
                    size: 24,
                  ),
                )),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

class ApiKeyInputDialog extends StatelessWidget {
  final ChatController chatController;
  final TextEditingController textController;

  ApiKeyInputDialog(this.chatController, {super.key})
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
