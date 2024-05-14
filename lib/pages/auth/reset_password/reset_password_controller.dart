// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/auth_service.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  var isLoading = false.obs;

  final AuthService _authService = Get.find<AuthService>();

  void resetPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar("Ошибка", "Введите Email адрес", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading(true);
      await _authService.resetPassword(emailController.text.trim());
    } catch (e) {
      print(e);
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
