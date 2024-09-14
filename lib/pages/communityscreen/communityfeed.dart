import 'package:flutter/material.dart';
import 'package:ovie/widgets/background_gradient.dart';
import 'package:ovie/pages/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'communitymenu.dart';
import 'communityposts.dart';
import 'package:ovie/pages/communityscreen/postactions/comments.dart';
import 'package:ovie/widgets/chat_icons.dart'; // Adjust the import as per your project structure

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isDrawerOpen = false;
  String _selectedCommunity = 'Your Communities';
  bool _isPostsSelected = true;
  late Future<QuerySnapshot> _postsFuture;
  String? _selectedCommunityId;
  bool _isChatsSelected = false; // New state for Chats

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _postsFuture = _fetchPosts();
  }

  Future<QuerySnapshot> _fetchPosts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _selectTab(bool isPosts, bool isChats) {
    setState(() {
      _isPostsSelected = isPosts;
      _isChatsSelected = isChats;

    });
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _postsFuture = _fetchPosts();
    });
  }

  void _selectCommunity(String communityId) {
    setState(() {
      _selectedCommunityId = communityId;
    });
  }

  void _closeOverlay() {
    setState(() {
      _selectedCommunityId = null;
    });
  }
void _showComments(String postId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: const EdgeInsets.only(top: 50.0), // Adjust the top padding as needed
      child: CommentsPage(postId: postId),
    ),
  );
}

  void _showAddPostDialog() {
    TextEditingController _postController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Write post here'),
          content: TextField(
            controller: _postController,
            maxLength: 600,
            maxLines: 5,
            decoration: InputDecoration(hintText: 'Write post here'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  var postData = {
                    'content': _postController.text,
                    'timestamp': FieldValue.serverTimestamp(),
                    'upvotes': 0,
                    'comments': [],
                    'replies': [],
                    'saved': false,
                    'userId': user.uid,
                    'username': user.displayName ?? 'Anonymous',
                  };
                  print("Adding post data: $postData"); // Print statement
                  await FirebaseFirestore.instance.collection('posts').add(postData);
                  Navigator.of(context).pop();
                  _refreshPosts();
                }
              },
              child: Text('Post'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            _buildMainContent(),
            CommunityMenu(
              animationController: _animationController,
              isDrawerOpen: _isDrawerOpen,
              selectedCommunity: _selectedCommunity,
              onCommunitySelected: (String newValue) {
                setState(() {
                  _selectedCommunity = newValue;
                });
              },
              onCommunitySelectedForOverlay: _selectCommunity,
            ),
            if (_selectedCommunityId != null)
              CommunityPostsOverlay(
                communityId: _selectedCommunityId!,
                onClose: _closeOverlay,
              ),
          ],
        ),
      ),
    );
  }

 Widget _buildMainContent() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(250 * _animationController.value, 0),
          child: BackgroundGradient(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Color(0xFF010101), // Black background
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: _toggleDrawer,
                ),
                title: _buildTabs(),
                actions: [
                  IconButton(
                    icon: Icon(Icons.message, color: Colors.white),
                    onPressed: () => _selectTab(false, true), // When chat icon is pressed, display chat
                  ),
                ],
              ),
              // Display the correct content based on the selected tab
              body: _isChatsSelected
                  ? ChatScreen() // If the chat is selected, show the ChatScreen
                  : _isPostsSelected
                      ? _buildPostsContent() // Show posts if selected
                      : _buildSavedContent(), // Otherwise show saved content
            ),
          ),
        );
      },
    );
  }




Widget _buildPostsContent() {
  return FutureBuilder<QuerySnapshot>(
    future: _postsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No posts available.', style: TextStyle(color: Colors.white)));
      }

      return ListView(
        padding: EdgeInsets.zero, // No padding at the top or bottom of the posts
        children: snapshot.data!.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(data['userId']).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasError) {
                return Center(child: Text('Error: ${userSnapshot.error}', style: TextStyle(color: Colors.white)));
              }
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Center(child: Text('User not found', style: TextStyle(color: Colors.white)));
              }

              Map<String, dynamic> userData = userSnapshot.data!.data() as Map<String, dynamic>;
              String username = userData['username'] ?? 'Anonymous';
return Padding(
  padding: EdgeInsets.symmetric(vertical: 4.0), // Minimal space between posts
  child: Container(
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      color: Color(0xFF1C1C1C), // Darker color for post background
      borderRadius: BorderRadius.circular(8), // Slightly rounded corners
      border: Border.all(color: Colors.grey.shade700, width: 1),
    ),
    child: ListTile(
      tileColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // Consistent padding within the post
      title: Row(
        children: [
          CircleAvatar(
            radius: 20, // Avatar size
            backgroundColor: Color.fromARGB(255, 124, 90, 236), // Avatar background color
            child: Text(username[0]), // Display first letter of username
          ),
          SizedBox(width: 10),
          Text(
            username,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Open post options menu
            },
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['content'],
            style: TextStyle(color: Colors.grey[300]),
          ),
          SizedBox(height: 8), // Slightly reduced spacing
          Row(
            children: [
              _buildTag('Cramps'), // Example tag, can be dynamic
              SizedBox(width: 5),
              _buildTag('PCOS'), // Another example tag
            ],
          ),
          SizedBox(height: 8), // Space before icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildIconText(
                    icon: Icons.arrow_upward_rounded,
                    text: data['upvotes'].toString(),
                    color: Color.fromARGB(255, 124, 90, 236),
                    onTap: () {
                      // Implement upvote functionality
                    },
                  ),
                  SizedBox(width: 20),
                  _buildIconText(
                    icon: Icons.bookmark,
                    text: '',
                    color: Color.fromARGB(255, 124, 90, 236),
                    onTap: () {
                      // Implement downvote functionality
                      print ('saved clicked');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  _buildIconText(
                    icon: Icons.comment,
                    text: data['comments'].isNotEmpty ? data['comments'].length.toString() : '0',
                    color: Color.fromARGB(255, 124, 90, 236),
                    onTap: () {
                      _showComments(doc.id); // Call the _showComments function with the post ID
                    },
                  ),
                  SizedBox(width: 20),
                  _buildIconText(
                    icon: Icons.share,
                    text: '',
                    color: Color.fromARGB(255, 124, 90, 236),
                    onTap: () {
                      print('share button clicked');
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      isThreeLine: true,
    ),
  ),
);

            },
          );
        }).toList(),
      );
    },
  );
}


Widget _buildIconText({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
  required Color color,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        Icon(icon, color: color, size: 18), // Slightly smaller icon size
        SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(color: color),
        ),
      ],
    ),
  );
}
  Widget _buildSavedContent() {
    return Center(child: Text('No Saves Added')); // Replace with actual saved content
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _selectTab(true, false), // Set to Posts view
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _isPostsSelected ? Color.fromARGB(255, 124, 90, 236) : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Posts',
              style: TextStyle(
                color: _isPostsSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () => _selectTab(false, false), // Set to Saved view
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: !_isPostsSelected && !_isChatsSelected ? Color.fromARGB(255, 124, 90, 236) : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Saved',
              style: TextStyle(
                color: !_isPostsSelected && !_isChatsSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
Widget _buildTag(String tagName) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 124, 90, 236), // Background for tag
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      tagName,
      style: TextStyle(color: Colors.white, fontSize: 12),
    ),
  );
}

}
