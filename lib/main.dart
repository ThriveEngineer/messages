import 'package:flutter/material.dart';
import 'package:messages/components/themes/dark_mode.dart';
import 'package:messages/components/themes/light_mode.dart';
import 'package:messages/services/auth/login_or_register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginOrRegister(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
