// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class UsersService extends GetxService {
  Stream<List<Map<String, dynamic>>> listenToUsers() {
    return FirebaseDatabase.instance.ref('users').onValue.map((event) {
      final userList = <Map<String, dynamic>>[];
      final data = event.snapshot.value;

      if (data != null && data is Map) {
        data.forEach((key, value) {
          if (value is Map) {
            userList.add(Map<String, dynamic>.from(value));
          } else if (value is String) {
            userList.add({'uid': key, 'value': value});
          } else {
            print("Error: Invalid data format for user with key $key");
          }
        });
      } else {
        print("Error: No data found or invalid data format");
      }

      return userList;
    }).handleError((error) {
      print("Error: $error");
      return [];
    });
  }
}
