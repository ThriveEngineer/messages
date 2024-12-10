import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messages/pages/chat_home.dart';
import 'package:messages/pages/chat_home_pc.dart';
import 'package:messages/pages/home_page.dart';
import 'package:messages/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          
          // user is logged in
          if (snapshot.hasData) {
            return currentWidth < 600 ? ChatHomeScreen(
      currentUserEmail: FirebaseAuth.instance.currentUser!.email!,) : ChatHomeScreenPc(currentUserEmail: FirebaseAuth.instance.currentUser!.email!,);
          }
          // user is NOT logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}