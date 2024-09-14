import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ovie/widgets/background_gradient.dart';
import 'package:intl/intl.dart'; 

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Timestamp timestamp;

  MessageBubble({required this.message, required this.isMe, required this.timestamp});

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMM d, h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? Color(0xFFFDD7E0) : Color(0xFFD2D3FA), // Pink for sent, purple for received
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: isMe ? Radius.circular(20) : Radius.circular(0),
            bottomRight: isMe ? Radius.circular(0) : Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.black : const Color.fromARGB(255, 0, 0, 0), // White for received text
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatTimestamp(timestamp),
              style: TextStyle(
                color: isMe ? Colors.black54 : Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivateChatScreen extends StatefulWidget {
  final String chatId;
  final String peerId;
  final String peerUsername;

  PrivateChatScreen({
    required this.chatId,
    required this.peerId,
    required this.peerUsername,
  });

  @override
  _PrivateChatScreenState createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || _messageController.text.trim().isEmpty) return;

    var messageData = {
      'chatId': widget.chatId,
      'senderId': currentUser.uid,
      'text': _messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add(messageData);

    _messageController.clear();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .update({
      'lastMessage': messageData['text'],
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color(0xFF181A20), // Solid dark background
    body: Column(
      children: [
        AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white), // Changed color to white
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.peerUsername,
            style: TextStyle(color: Color.fromARGB(255, 174, 174, 174)), // White text color
          ),
          backgroundColor: Color(0xFF252B33), // Darker background for app bar
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(widget.chatId)
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No messages.', style: TextStyle(color: Colors.white)));
              }
              return ListView(
                reverse: true,
                children: snapshot.data!.docs.map((doc) {
                  var messageData = doc.data() as Map<String, dynamic>;
                  bool isMe = messageData['senderId'] == FirebaseAuth.instance.currentUser!.uid;
                  return MessageBubble(
                    message: messageData['text'],
                    isMe: isMe,
                    timestamp: messageData['timestamp'],
                  );
                }).toList(),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Color(0xFF7C5AEC)),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}