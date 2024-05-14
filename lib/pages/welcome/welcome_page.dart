import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('welcome_title'.tr)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('welcome_subtitle'.tr, textAlign: TextAlign.center),
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/signin');
              },
              child: Text('welcome_signin'.tr),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/signup');
              },
              child: Text('welcome_sighup'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
