import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String message;
  final Timestamp timestamp;
  final String receiverID;

  Message({
    required this.senderID, 
    required this.senderEmail, 
    required this.message, 
    required this.timestamp, 
    required this.receiverID
    });

    // convert to a map
    Map<String, dynamic> toMap() {
      return {
        'senderID': senderID,
        'senderEmail': senderEmail,
        'message': message,
        'timestamp': timestamp,
        'receiverID': receiverID
      };
    }
}