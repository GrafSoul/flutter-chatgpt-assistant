// auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/app_routes.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GetStorage _storage = GetStorage();

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        var userRef = _database.ref('users/${user.uid}');
        var snapshot = await userRef.get();
        if (snapshot.exists) {
          var userData = snapshot.value as Map<dynamic, dynamic>;
          _storage.write('userData', userData);
        }
      }
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
      if (user != null) {
        await user.updateDisplayName(name);

        final usersSnapshot = await _database.ref('users').get();
        String role = usersSnapshot.exists && usersSnapshot.children.isNotEmpty ? 'user' : 'admin';

        var userData = {'name': name, 'email': email, 'role': role};
        await _database.ref('users/${user.uid}').set(userData);

        _storage.write('userData', userData);

        Get.snackbar("Успешно", "Регистрация прошла успешно", snackPosition: SnackPosition.TOP);
        Get.offAllNamed('/chat');
      }
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

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    _storage.remove('userData');
    Get.offAllNamed(Routes.WELCOME);
  }
}
