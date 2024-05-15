import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Settings')),
      body: Obx(() {
        var user = controller.firebaseUser.value;
        if (user == null) return const Center(child: CircularProgressIndicator());

        profileController.nameController.text = user.displayName ?? '';
        profileController.emailController.text = user.email ?? '';

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: profileController.nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            ElevatedButton(
              onPressed: () => controller.updateUserName(profileController.nameController.text),
              child: const Text('Save Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: profileController.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: () => controller.updateUserEmail(profileController.emailController.text),
              child: const Text('Save Email'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: profileController.currentPasswordController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            TextField(
              controller: profileController.newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextField(
              controller: profileController.confirmNewPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                if (profileController.newPasswordController.text ==
                    profileController.confirmNewPasswordController.text) {
                  controller.updateUserPassword(
                      profileController.currentPasswordController.text, profileController.newPasswordController.text);
                } else {
                  Get.snackbar('Error', 'Passwords do not match');
                }
              },
              child: const Text('Change Password'),
            ),
          ],
        );
      }),
    );
  }
}
