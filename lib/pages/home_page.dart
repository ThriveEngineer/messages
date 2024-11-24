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
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        title: Center(child: const Text('Home')),
        actions: [
          PopupMenuButton(
            shadowColor: Colors.transparent,
            color: Theme.of(context).colorScheme.tertiary,
            icon: const Icon(CupertinoIcons.ellipsis_circle),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: TextButton(
              onPressed: logout, 
              child: Text("Logout")
              ),
             ),
             PopupMenuItem(
                child: TextButton(
              onPressed: () {}, 
              child: Text("Blocked Users")
              ),
             ),
             PopupMenuItem(
                child: TextButton(
              onPressed: () {}, 
              child: Text(
                "Delete Account",
                style: TextStyle(color: Colors.red),
                )
              ),
             ),
            ],
           )
        ],
        leading: const Icon(CupertinoIcons.ellipsis_circle),
      ),
    );
  }
}