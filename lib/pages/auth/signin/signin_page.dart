import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signin_controller.dart';

class SignInPage extends StatelessWidget {
  final SignInController controller = Get.put(SignInController());

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Вход")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Пароль'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.signIn,
                    child: Text(controller.isLoading.value ? 'Загрузка...' : 'Войти')),
              ],
            ),
          );
        }),
      ),
    );
  }
}
