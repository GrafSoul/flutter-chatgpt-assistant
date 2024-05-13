import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  var isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void signUp() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar("Ошибка", "Все поля должны быть заполнены", snackPosition: SnackPosition.TOP);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Ошибка", "Пароль не совпадают", snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      isLoading(true);
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User? user = userCredential.user;
      await user?.updateDisplayName(nameController.text.trim());
      Get.snackbar("Успешно", "Регистрация прошла успешно", snackPosition: SnackPosition.TOP);
      Get.offAll('/chat');
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
    confirmPasswordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
