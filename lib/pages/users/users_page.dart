// user_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './users_controller.dart';

class UsersPage extends GetView<UsersController> {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UsersController usersController = Get.put(UsersController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              usersController.onInit();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (usersController.usersList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: usersController.usersList.length,
          itemBuilder: (context, index) {
            var user = usersController.usersList[index];
            return ListTile(
              title: Text('Name: ${user['name'] ?? 'No name provided'} - Role: ${user['role'] ?? 'No role provided'}'),
              subtitle: Text('${user['email'] ?? 'No email provided'}'),
              trailing: const Icon(Icons.arrow_forward),
            );
          },
        );
      }),
    );
  }
}
