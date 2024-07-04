import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ovie/widgets/background_gradient.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _messagesCollection = FirebaseFirestore.instance.collection('chats');
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('chats').add({
        'text': _controller.text,
        'senderId': _currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _controller.clear();
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 252, 208, 208),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Global Chat', style: TextStyle(color: Colors.black)),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: _messagesCollection.orderBy('timestamp', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    var messages = snapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        var message = messages[index];
                        return ListTile(
                          title: Text(message['text']),
                        );
                      },
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
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          _messagesCollection.add({
                            'senderId': _currentUser?.uid,
                            'text': _controller.text,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          _controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
