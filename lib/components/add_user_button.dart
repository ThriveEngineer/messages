import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:messages/components/chat_bubble.dart';
import 'package:messages/components/my_textfield.dart';
import 'package:messages/services/auth/auth_service.dart';
import 'package:messages/services/chat/chat_services.dart';

class ChatButton extends StatefulWidget {
  final String currentUserEmail;
  
  const ChatButton({
    Key? key,
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  State<ChatButton> createState() => _ChatButtonState();
}

class _ChatButtonState extends State<ChatButton> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _startChat(String targetEmail) async {
    if (targetEmail == widget.currentUserEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot chat with yourself')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check if user exists in Firebase
      final userSnapshot = await _firestore
          .collection('Users')
          .where('email', isEqualTo: targetEmail)
          .get();

      if (userSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
        return;
      }

      // Create or get existing chat room
      final chatRoomId = _getChatRoomId(widget.currentUserEmail, targetEmail);
      final chatRoomRef = _firestore.collection('chat_rooms').doc(chatRoomId);
      
      final chatRoomSnapshot = await chatRoomRef.get();

      if (!chatRoomSnapshot.exists) {
        // Create new chat room
        await chatRoomRef.set({
          'participants': [widget.currentUserEmail, targetEmail],
          'lastMessage': '',
          'lastMessageTime': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Navigate to chat screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatRoomId: chatRoomId,
              currentUserEmail: widget.currentUserEmail,
              otherUserEmail: targetEmail,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getChatRoomId(String email1, String email2) {
    // Sort emails to ensure consistent chat room IDs
    final sortedEmails = [email1, email2]..sort();
    return '${sortedEmails[0]}_${sortedEmails[1]}';
  }

  void _showAddChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start New Chat'),
        content: TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'Enter user email',
            labelText: 'Email',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_emailController.text.isNotEmpty) {
                Navigator.pop(context);
                _startChat(_emailController.text.trim());
              }
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      onPressed: _isLoading ? null : _showAddChatDialog,
      child: _isLoading
          ? CircularProgressIndicator(color: Theme.of(context).colorScheme.inversePrimary,)
          : Icon(Icons.add_rounded, color: Theme.of(context).colorScheme.inversePrimary, size: 30,),
    );
  }
}

// Basic Chat Screen widget
class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String currentUserEmail;
  final String otherUserEmail;

  const ChatScreen({
    Key? key,
    required this.chatRoomId,
    required this.currentUserEmail,
    required this.otherUserEmail,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserEmail),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: MessagesList(
              chatRoomId: widget.chatRoomId,
              currentUserEmail: widget.currentUserEmail,
            ),
          ),
          MessageInput(
            chatRoomId: widget.chatRoomId,
            currentUserEmail: widget.currentUserEmail,
            otherUserEmail: widget.otherUserEmail,
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final dynamic timestamp; // Changed to dynamic to handle null

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    required this.timestamp,
  }) : super(key: key);

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return 'Sending...';
    }
    
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return DateFormat('HH:mm').format(date);
    }
    
    return 'Invalid time';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blueAccent : Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(45),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: isCurrentUser ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTimestamp(timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: isCurrentUser ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Also update the MessagesList widget to handle the timestamp safely:
class MessagesList extends StatelessWidget {
  final String chatRoomId;
  final String currentUserEmail;

  const MessagesList({
    Key? key,
    required this.chatRoomId,
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
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
            child: Text('No messages yet. Start the conversation!'),
          );
        }

        return ListView.builder(
          reverse: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            
            final isCurrentUser = data['senderEmail'] == currentUserEmail;
            final timestamp = data['timestamp']; // Don't cast to Timestamp here

            return MessageBubble(
              message: data['message'] as String,
              isCurrentUser: isCurrentUser,
              timestamp: timestamp,
            );
          },
        );
      },
    );
  }
}

class MessageInput extends StatefulWidget {
  final String chatRoomId;
  final String currentUserEmail;
  final String otherUserEmail;

  const MessageInput({
    Key? key,
    required this.chatRoomId,
    required this.currentUserEmail,
    required this.otherUserEmail,
  }) : super(key: key);

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final message = _controller.text.trim();
      final timestamp = FieldValue.serverTimestamp();

      // Add message to the messages subcollection
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add({
        'message': message,
        'senderEmail': widget.currentUserEmail,
        'timestamp': timestamp,
      });

      // Update the chat room's last message
      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(widget.chatRoomId)
          .update({
        'lastMessage': message,
        'lastMessageTime': timestamp,
      });

      _controller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: currentWidth < 600 ? const EdgeInsets.only(bottom: 10, left: 10, right: 10) : const EdgeInsets.only(bottom: 10, left: 20, right: 20),
      child: Container(
        padding: currentWidth < 600 ? const  EdgeInsets.all(8) : const  EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          color: Theme.of(context).colorScheme.tertiary,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            IconButton(
              onPressed: _isLoading ? null : _sendMessage,
              icon: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}