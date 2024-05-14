// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/auth_service.dart';

class SignUpController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  var isLoading = false.obs;

  final AuthService _authService = Get.find<AuthService>();

  void signUp() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('signup_error'.tr, 'signup_error_empty_fields'.tr, snackPosition: SnackPosition.TOP);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('signup_error'.tr, 'signup_error_passwords_not_match'.tr, snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      isLoading(true);
      await _authService.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
      );
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
  }
}
