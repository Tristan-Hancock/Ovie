import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Timestamp timestamp;

  MessageBubble({required this.message, required this.isMe, required this.timestamp});

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? Color(0xFFBBBFFE) : Color(0xFFFDD7E0), // Updated message colors
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
                color: Color(0xFF101631), // Blackish text color for both sent/received
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatTimestamp(timestamp),
              style: TextStyle(
                color: Color(0xFFA9A9A9), // Grey for timestamp
                fontSize: 10,
                fontStyle: FontStyle.italic,
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
      backgroundColor: Color(0xFF101631), // Updated background color (dark blue)
      body: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white), 
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.peerUsername,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF101631), // Dark blue AppBar
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white), // Three dots menu
                onPressed: () {
                  // Add action logic here
                },
              ),
            ],
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
  padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
  child: Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white, // White background for the input
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.only(right: 60), // Leave space for the send button
        child: TextField(
          controller: _messageController,
          decoration: InputDecoration(
            hintText: 'Type your message...',
            hintStyle: TextStyle(color: Color(0xFFA9A9A9)), // Placeholder color
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
      Positioned(
        right: 10, // Positioning the send button on the right inside the text field
        top: 0,
        bottom: 0,
        child: GestureDetector(
          onTap: _sendMessage,
          child: Image.asset(
            'assets/icons/send.png',
            height: 24,
          ),
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
