// ignore_for_file: avoid_print

import 'package:get/get.dart';
import '../../services/users_service.dart';

class UsersController extends GetxController {
  RxList<Map<String, dynamic>> usersList = RxList<Map<String, dynamic>>();
  final UsersService usersService = Get.put(UsersService());

  @override
  void onInit() {
    usersList.bindStream(usersService.listenToUsers());
    super.onInit();
  }
}
