// user_controller.dart
// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class UsersController extends GetxController {
  RxList<dynamic> usersList = RxList<dynamic>();

  @override
  void onInit() {
    usersList.bindStream(listenToUsers());
    super.onInit();
  }

  Stream<List<dynamic>> listenToUsers() {
    return FirebaseDatabase.instance.ref('users').onValue.map((event) {
      final userList = <dynamic>[];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        data.forEach((key, value) {
          userList.add(value as Map<dynamic, dynamic>);
        });
      } else {
        print("Error: No data found");
      }
      return userList;
    }).handleError((error) {
      print("Error: $error");
      return [];
    });
  }
}
