import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController extends GetxController {
  Rxn<User> firebaseUser = Rxn<User>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update name: $e');
    }
  }

  void updateUserEmail(String email) async {
    try {
      await firebaseUser.value!.verifyBeforeUpdateEmail(email);
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update email: $e');
    }
  }

  void updateUserPassword(String password, String text) async {
    try {
      await firebaseUser.value!.updatePassword(password);
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update password: $e');
    }
  }
}
