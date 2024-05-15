import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  Rxn<User> firebaseUser = Rxn<User>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage _storage = GetStorage();
  RxMap<dynamic, dynamic> userData = RxMap<dynamic, dynamic>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  @override
  void onReady() {
    userData.value = _storage.read('userData');
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }

  void updateUserName(String name) async {
    try {
      await firebaseUser.value!.updateDisplayName(name);
      Get.snackbar('Успешно', 'Имя пользователя было изменено');
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update name: $e');
    }
  }

  void updateUserEmail(String email) async {
    try {
      await firebaseUser.value!.verifyBeforeUpdateEmail(email);
      Get.snackbar('Успешно', 'Email пользователя был изменен');
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update email: $e');
    }
  }

  void updateUserPassword(String currentPassword, String newPassword) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: firebaseUser.value!.email!, password: currentPassword);
      userCredential.user!.updatePassword(newPassword).then((_) {
        Get.snackbar('Success', 'Password successfully changed');
      }).catchError((error) {
        Get.snackbar('Error', 'Failed to change password: $error');
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to verify user: $e');
    }
  }
}
