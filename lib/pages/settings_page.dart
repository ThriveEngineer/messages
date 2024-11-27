import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messages/components/clickable_link.dart';
import 'package:messages/services/auth/auth_gate.dart';
import 'package:messages/services/auth/auth_service.dart';
import 'package:messages/services/auth/login_or_register.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        title: Padding(
          padding: const EdgeInsets.only(left: 110),
          child: Text(
              'Settings',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.w500
                ),
              ),
        ),
      ),

      body: Column(
        children: [

          // Dark Mode Switch
          Center(
               child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.secondary
                ),
                child: Row(
                  children: [
                  Text(
                  'Dark Mode', 
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.w500
                    ),
                   ),
                  ],
                ),
                           ),
             ),

             SizedBox(height: 15,),

          // Blocked users
          Center(
               child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.secondary
                ),
                child: Row(
                  children: [
                  Text(
                  'Blocked Users', 
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.w500
                    ),
                   ),

                   SizedBox(width: 190),
                   Icon(
                    Icons.arrow_forward_rounded, 
                    color: Theme.of(context).colorScheme.inversePrimary
                    ),
                  ],
                ),
                           ),
             ),

             SizedBox(height: 15,),

          // logout button
             Center(
               child: GestureDetector(
                onTap: () {
                  logout();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => AuthGate()));
                },
                 child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent
                  ),
                  child: Row(
                    children: [
                    Text(
                    'Logout', 
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.w500
                      ),
                     ),
                 
                     SizedBox(width: 240),
                     Icon(
                      Icons.arrow_forward_rounded, 
                      color: Theme.of(context).colorScheme.inversePrimary
                      ),
                    ],
                  ),
                             ),
               ),
             ),

             SizedBox(height: 15,),

             Divider(endIndent: 45, indent: 45,),

             SizedBox(height: 15,),

             // GitHub name
             SelectableText(
              "GitHub: @ThriveEngineer",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
             ),

             SizedBox(height: 10,),

             // Support me
             SelectableText(
              "Support me: https://ko-fi.com/thriveengineer",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
             ),

             SizedBox(height: 10,),

             // Bento link
             SelectableText(
              "Other Links: https://bento.me/thrive",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
             ),
             
        ],
      ),
    );
  }
}