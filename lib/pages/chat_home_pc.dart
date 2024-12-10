import 'package:flutter/material.dart';
import 'package:messages/components/add_user_button.dart';
import 'package:messages/components/my_drawer.dart';
import 'package:messages/pages/chat_home.dart';
import 'package:messages/pages/settings_page.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        leading: IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () {
            Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage()
                       ),
                      );
          },
          ),
      ),
      
      body: ChatRoomsList(currentUserEmail: widget.currentUserEmail),
      floatingActionButton: ChatButton(currentUserEmail: widget.currentUserEmail),
    );
  }
}