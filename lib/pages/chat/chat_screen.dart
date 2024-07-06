import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ovie/widgets/background_gradient.dart';
import 'private_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: Column(
          children: [
            AppBar(
              title: Text('Chats'),
              backgroundColor: Color.fromARGB(255, 252, 208, 208),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query.trim();
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _searchQuery.isEmpty
                    ? FirebaseFirestore.instance.collection('users').snapshots()
                    : FirebaseFirestore.instance
                        .collection('users')
                        .where('username', isGreaterThanOrEqualTo: _searchQuery)
                        .where('username', isLessThanOrEqualTo: '$_searchQuery\uf8ff')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No users found.'));
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      var userData = doc.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(userData['username'] ?? 'Unknown'),
                        subtitle: Text(userData['email'] ?? 'No email'),
                        onTap: () {
                          _startChat(context, doc.id, userData['username']);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startChat(BuildContext context, String userId, String username) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    String chatId = await _getOrCreateChatId(currentUser.uid, userId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivateChatScreen(
          chatId: chatId,
          peerId: userId,
          peerUsername: username,
        ),
      ),
    );
  }

  Future<String> _getOrCreateChatId(String userId1, String userId2) async {
    String chatId;
    var chats = await FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: userId1)
        .get();

    if (chats.docs.isNotEmpty) {
      for (var chat in chats.docs) {
        if ((chat['members'] as List).contains(userId2)) {
          chatId = chat.id;
          return chatId;
        }
      }
    }

    var newChat = await FirebaseFirestore.instance.collection('chats').add({
      'members': [userId1, userId2],
      'lastMessage': '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    return newChat.id;
  }
}
