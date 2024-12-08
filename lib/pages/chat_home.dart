import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:messages/components/add_user_button.dart';
import 'package:messages/components/my_drawer.dart';

class ChatHomeScreen extends StatelessWidget {
  final String currentUserEmail;

  const ChatHomeScreen({
    Key? key,
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      body: ChatRoomsList(currentUserEmail: currentUserEmail),
      floatingActionButton: ChatButton(currentUserEmail: currentUserEmail),
    );
  }
}

class ChatRoomsList extends StatelessWidget {
  final String currentUserEmail;

  const ChatRoomsList({
    Key? key,
    required this.currentUserEmail,
  }) : super(key: key);

  String _getOtherUserEmail(List<dynamic> participants) {
    return participants.firstWhere((email) => email != currentUserEmail) as String;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat_rooms')
          .where('participants', arrayContains: currentUserEmail)
          .orderBy('lastMessageTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No chats yet. Start a new conversation!'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final otherUserEmail = _getOtherUserEmail(data['participants'] as List<dynamic>);
            final lastMessage = data['lastMessage'] as String;
            final lastMessageTime = data['lastMessageTime'] as Timestamp?;

            return ChatRoomListTile(
              chatRoomId: doc.id,
              otherUserEmail: otherUserEmail,
              lastMessage: lastMessage,
              lastMessageTime: lastMessageTime,
              currentUserEmail: currentUserEmail,
            );
          },
        );
      },
    );
  }
}

class ChatRoomListTile extends StatelessWidget {
  final String chatRoomId;
  final String otherUserEmail;
  final String lastMessage;
  final Timestamp? lastMessageTime;
  final String currentUserEmail;

  const ChatRoomListTile({
    Key? key,
    required this.chatRoomId,
    required this.otherUserEmail,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.currentUserEmail,
  }) : super(key: key);

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      // Today - show time
      return DateFormat('HH:mm').format(date);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(date); // Day name
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(
          otherUserEmail[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(otherUserEmail),
      subtitle: Text(
        lastMessage.isEmpty ? 'No messages yet' : lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(_formatTimestamp(lastMessageTime)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatRoomId: chatRoomId,
              currentUserEmail: currentUserEmail,
              otherUserEmail: otherUserEmail,
            ),
          ),
        );
      },
    );
  }
}