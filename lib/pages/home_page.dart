import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messages/components/my_drawer.dart';
import 'package:messages/components/user_tile.dart';
import 'package:messages/services/auth/auth_service.dart';
import 'package:messages/services/chat/chat_services.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // chat @ auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        title: Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Text(
              'Messages',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.w500
                ),
              ),
        ),
      ),
      drawer: const MyDrawer(),

      body: _buildUserList(),
    );
  }

  // build user list
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(), 
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // return list view
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem).toList(),
        );
      }
      );
  }

  // build user list item
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    return UserTile();
  }
}