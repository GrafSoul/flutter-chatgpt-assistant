import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_controller.dart';

class SignUpPage extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('signup_title'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: controller.nameController,
                  decoration: InputDecoration(labelText: 'signup_name'.tr),
                ),
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(labelText: 'signup_email'.tr),
                ),
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'signup_password'.tr),
                ),
                TextField(
                  controller: controller.confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'signup_confirm_password'.tr),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.signUp,
                    child: Text(controller.isLoading.value ? 'signup_loading'.tr : 'signup_enter'.tr)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
