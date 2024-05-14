// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/auth_service.dart';

class SignInController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;

  final AuthService _authService = Get.find<AuthService>();

  void signIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('signin_error'.tr, 'signin_error_empty'.tr, snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      isLoading(true);
      await _authService.signIn(emailController.text.trim(), passwordController.text.trim());
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
