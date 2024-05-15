import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import '../../services/profile_service.dart';

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

  final ProfileService _profileService = Get.find<ProfileService>();

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

  void updateUserName(String name) {
    _profileService.updateUserName(name).then((success) {
      if (success) {
        userData['name'] = name;
        userData.refresh();
      }
    });
  }

  void updateUserEmail(String email) {
    _profileService.updateUserEmail(email).then((success) {
      if (success) {
        userData['email'] = email;
        userData.refresh();
      }
    });
  }

  void updateUserPassword(String currentPassword, String newPassword) {
    _profileService.updateUserPassword(currentPassword, newPassword);
  }
}
