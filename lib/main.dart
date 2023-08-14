import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/authentication/login_screen.dart';
import 'package:shop_app/users/fragments/dashboard.dart';
import 'package:shop_app/users/userPreferences/user_references.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: RememberUserPrefs.readUser(),
          builder: (context, dataSnapShot) {
            if (dataSnapShot.data == null) {
              return const LoginScreen();
            } else {
              return Dashboard();
            }
          }),
    );
  }
}
