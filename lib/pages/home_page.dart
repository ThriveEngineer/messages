import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messages/services/auth/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: logout, 
            icon: Icon(CupertinoIcons.square_arrow_left),
            ),
        ],
      ),
    );
  }
}