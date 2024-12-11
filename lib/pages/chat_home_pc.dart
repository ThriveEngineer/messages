import 'package:flutter/material.dart';
import 'package:messages/components/add_user_button.dart';
import 'package:messages/components/my_drawer.dart';
import 'package:messages/pages/chat_home.dart';
import 'package:messages/pages/settings_page.dart';
import 'package:messages/services/auth/auth_gate.dart';
import 'package:messages/services/auth/auth_service.dart';

class ChatHomeScreenPc extends StatefulWidget {
  final String currentUserEmail;

  const ChatHomeScreenPc({
    Key? key,
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  State<ChatHomeScreenPc> createState() => _ChatHomeScreenPcState();
}

class _ChatHomeScreenPcState extends State<ChatHomeScreenPc> {
  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        leading: IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () {
            logout();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => AuthGate()));
          },
          ),
      ),
      
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            ),
            width: 370,
            height: 10000,
            child: ChatRoomsList(
              currentUserEmail: widget.currentUserEmail,
              ),
          ),
        ],
      ),
      floatingActionButton: ChatButton(currentUserEmail: widget.currentUserEmail),
    );
  }
}