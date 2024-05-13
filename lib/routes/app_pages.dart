import 'package:get/get.dart';

import '../pages/welcome/welcome_page.dart';
import '../pages/chat/chat_page.dart';
import '../pages/auth/signup/signup_page.dart';
import '../pages/auth/signin/signin_page.dart';
import '../pages/auth/reset_password/reset_password_page.dart';

import '../pages/auth/signup/signup_binding.dart';
import '../pages/auth/signin/signin_binding.dart';
import '../pages/auth/reset_password/reset_password_binding.dart';
import '../pages/chat/chat_binding.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.WELCOME,
      page: () => const WelcomePage(),
    ),
    GetPage(
      name: Routes.SIGNIN,
      page: () => SignInPage(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignUpPage(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD,
      page: () => ResetPasswordPage(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
  ];
}
