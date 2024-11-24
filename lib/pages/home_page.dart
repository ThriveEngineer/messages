import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messages/components/my_drawer.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        title: Center(
          child: Text(
            'Messages',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.w500
              ),
            ),
        ),
        actions: [
           IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout_rounded),
            ),
          ]
      ),
      drawer: MyDrawer(),

      body: Column(
        children: [

        ],
      ),
    );
  }
}