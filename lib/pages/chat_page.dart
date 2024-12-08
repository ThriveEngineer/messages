import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messages/components/chat_bubble.dart';
import 'package:messages/components/my_textfield.dart';
import 'package:messages/services/auth/auth_service.dart';
import 'package:messages/services/chat/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

   ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
    // text controller
    final TextEditingController _messageController = TextEditingController();

    // chat & auth services
    final ChatService _chatService = ChatService();

    final AuthService _authService = AuthService();

    // for textfield focus
    FocusNode myFocusNode = FocusNode();

    @override
  void initState() {
    super.initState();

    // add listner to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), 
        () => scrollDown(),
        );
      }
    });

    // scroll down
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn
    );
  }

    // send message
    void sendMessage() async {
      if (_messageController.text.isNotEmpty) {
        await _chatService.sendMessage(widget.receiverID, _messageController.text);

        // clear text field
        _messageController.clear();
      }

      scrollDown();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(child: buildMessageList(),
          ),

          // user input field
          _buildUserInput(),
        ],
      ),
    );
  }

  // build message list
  Widget buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderID, widget.receiverID),
      builder: (context, snapshot) {

        // errors
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // return list view
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    // align messages right
    var alignment = 
    isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser,)
        ],
      ));
  }

  // build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25, right: 25,),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              controller: _messageController,
              hintText: "Type your message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.redAccent,
            shape: BoxShape.circle
            ),
            child: IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward_rounded)))
        ],
      ),
    );
  }
}