// auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Успешно", "Вы успешно вошли в систему", snackPosition: SnackPosition.TOP);
      Get.offAllNamed('/chat');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Ошибка", e.message ?? "Неизвестная ошибка", snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      await user?.updateDisplayName(name);
      Get.snackbar("Успешно", "Регистрация прошла успешно", snackPosition: SnackPosition.TOP);
      Get.offAllNamed('/chat');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Ошибка", e.message ?? "Неизвестная ошибка", snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Успешно", "Ссылка для сброса пароля отправлена на ваш Email", snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed('/signin');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Ошибка", e.message ?? "Неизвестная ошибка", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
