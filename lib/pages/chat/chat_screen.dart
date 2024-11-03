import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'private_chat_screen.dart';
import 'dart:math';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
Color _getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

// Function to generate a gradient using two random colors
LinearGradient _getRandomGradient() {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      _getRandomColor(),
      _getRandomColor(),
    ],
  );
}

 Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white, // Set background color to white
    body: Column(
      children: [
        SizedBox(height: 40), // Spacing at the top
        _buildSearchBar(), // Search bar at the top
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _getUsersStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No users found.', style: TextStyle(color: Colors.black)));
              }
              return _buildChatList(snapshot.data!.docs);
            },
          ),
        ),
      ],
    ),
  );
}

// Updated search bar styling
Widget _buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light background for search bar
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey), // Light grey hint text
          prefixIcon: Icon(Icons.search, color: Colors.grey), // Light grey search icon
          border: InputBorder.none,
        ),
        onChanged: (query) {
          setState(() {
            _searchQuery = query.trim();
          });
        },
      ),
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
      String username = userData['username'] ?? 'Unknown';
      String firstLetter = username.isNotEmpty ? username[0].toUpperCase() : 'U'; // Default to 'U' if username is empty

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.transparent, // Transparent background for the avatar container
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _getRandomGradient(), // Apply random gradient
              ),
              child: Center(
                child: Text(
                  firstLetter,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            username,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Black username
          ),
          subtitle: Text(
            userData['lastMessage'] ?? 'No messages yet',
            style: TextStyle(color: Colors.grey), // Grey subtitle for the last message
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '9:36 PM', // Placeholder time for now, update with real data
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Icon(Icons.more_vert, color: Colors.grey), // Grey dots icon for more options
            ],
          ),
          onTap: () {
            _startChat(context, docs[index].id, username);
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
