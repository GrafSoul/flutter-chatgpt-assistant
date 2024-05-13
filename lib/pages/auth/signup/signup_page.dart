import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_controller.dart';

class SignUpPage extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Регистрация")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(labelText: 'Имя пользователя'),
                ),
                TextField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Пароль'),
                ),
                TextField(
                  controller: controller.confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Подтвердите пароль'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.signUp,
                    child: Text(controller.isLoading.value ? 'Загрузка...' : 'Зарегистрироваться')),
              ],
            ),
          );
        }),
      ),
    );
  }
}
