import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  var isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void resetPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar("Ошибка", "Введите Email адрес", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading(true);
      await auth.sendPasswordResetEmail(email: emailController.text.trim());
      Get.snackbar("Успешно", "Ссылка для сброса пароля отправлена на ваш Email", snackPosition: SnackPosition.BOTTOM);
      Get.offAll('/signin');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Ошибка", e.message ?? "Неизвестная ошибка", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
