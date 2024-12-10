import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messages/components/themes/dark_mode.dart';
import 'package:messages/components/themes/light_mode.dart';
import 'package:messages/firebase_options.dart';
import 'package:messages/pages/chat_home.dart';
import 'package:messages/services/api/firebase_api.dart';
import 'package:messages/services/auth/auth_gate.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/message_page':(context) => ChatHomeScreen(
          currentUserEmail: FirebaseAuth.instance.currentUser!.email!,
          ),
      },
    );
  }
}
