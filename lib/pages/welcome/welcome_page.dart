import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Добро пожаловать!")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/signin');
              },
              child: const Text("Вход"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/signup');
              },
              child: const Text("Регистрация"),
            ),
          ],
        ),
      ),
    );
  }
}
