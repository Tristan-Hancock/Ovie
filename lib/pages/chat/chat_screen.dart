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
            SizedBox(height: 40), // For some spacing at the top
            _buildSearchBar(), // Search bar at the top
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getUsersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No users found.'));
                  }
                  return _buildChatList(snapshot.data!.docs);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Search bar widget
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
        ),
        onChanged: (query) {
          setState(() {
            _searchQuery = query.trim();
          });
        },
      ),
    );
  }

  // Fetch users based on the search query
  Stream<QuerySnapshot> _getUsersStream() {
    return _searchQuery.isEmpty
        ? FirebaseFirestore.instance.collection('users').snapshots()
        : FirebaseFirestore.instance
            .collection('users')
            .where('username', isGreaterThanOrEqualTo: _searchQuery)
            .where('username', isLessThanOrEqualTo: '$_searchQuery\uf8ff')
            .snapshots();
  }

  // Build chat list with avatars, usernames, and last message
  Widget _buildChatList(List<DocumentSnapshot> docs) {
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        var userData = docs[index].data() as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userData['avatarUrl'] ?? 'https://via.placeholder.com/150'),
              radius: 25,
            ),
            title: Text(
              userData['username'] ?? 'Unknown',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              userData['lastMessage'] ?? 'No messages yet',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '9:36 PM', // Placeholder time for now, update with real data
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
            onTap: () {
              _startChat(context, docs[index].id, userData['username']);
            },
          ),
        );
      },
    );
  }

  // Start chat logic (unchanged)
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

  // Fetch or create chat logic (unchanged)
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
