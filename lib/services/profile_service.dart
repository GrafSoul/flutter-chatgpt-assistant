import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class ProfileService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage _storage = GetStorage();
  Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<bool> updateUserName(String name) async {
    try {
      await firebaseUser.value!.updateDisplayName(name);
      var userData = _storage.read('userData') as Map<dynamic, dynamic>;
      userData['name'] = name;
      _storage.write('userData', userData);

      Get.snackbar('Успешно', 'Имя пользователя было изменено');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update name: $e');
      return false;
    }
  }

  Future<bool> updateUserEmail(String email) async {
    try {
      await firebaseUser.value!.verifyBeforeUpdateEmail(email);
      var userData = _storage.read('userData') as Map<dynamic, dynamic>;
      userData['email'] = email;
      _storage.write('userData', userData);

      Get.snackbar('Успешно', 'Email пользователя был изменен');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update email: $e');
      return false;
    }
  }

  Future<void> updateUserPassword(String currentPassword, String newPassword) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: firebaseUser.value!.email!, password: currentPassword);
      await userCredential.user!.updatePassword(newPassword);
      Get.snackbar('Success', 'Password successfully changed');
    } catch (e) {
      Get.snackbar('Error', 'Failed to change password: $e');
    }
  }
}
