import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signin_controller.dart';

class SignInPage extends StatelessWidget {
  final SignInController controller = Get.put(SignInController());

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('welcome_title'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(labelText: 'signin_email'.tr),
                ),
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'signin_password'.tr),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.signIn,
                  child: Text(controller.isLoading.value ? 'signin_loading'.tr : 'signin_enter'.tr),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/reset-password');
                  },
                  child:
                      Text('signin_forgot_password'.tr, style: const TextStyle(decoration: TextDecoration.underline)),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
