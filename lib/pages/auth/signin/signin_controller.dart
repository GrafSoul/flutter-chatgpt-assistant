import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void signIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Ошибка", "Email и пароль не могут быть пустыми", snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      isLoading(true);
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.snackbar("Успешно", "Вы успешно вошли в систему", snackPosition: SnackPosition.TOP);
      Get.offAllNamed('/chat');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Ошибка", e.message ?? "Неизвестная ошибка", snackPosition: SnackPosition.TOP);
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
