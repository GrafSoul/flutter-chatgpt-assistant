import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'reset_password_controller.dart';

class ResetPasswordPage extends StatelessWidget {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('reset_password_title'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(labelText: 'reset_password_enter_email'.tr),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.resetPassword,
                    child: Text(controller.isLoading.value ? 'Отправка...' : 'reset_password_send_email'.tr)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
