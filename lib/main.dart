import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_assistant/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import '/routes/app_pages.dart';

import '/services/auth_service.dart';
import '/services/users_service.dart';
import '/services/profile_service.dart';

import 'generated/locales.g.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AuthService());
  Get.put(UsersService());
  Get.put(ProfileService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return GetMaterialApp(
            title: 'ChatGPT Assistant',
            debugShowCheckedModeBanner: false,
            translationsKeys: AppTranslation.translations,
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('en', 'US'),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute: snapshot.hasData ? Routes.CHAT : Routes.WELCOME,
            getPages: AppPages.pages,
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
