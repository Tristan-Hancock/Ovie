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

  void _selectTab(bool isPosts) {
    setState(() {
      _isPostsSelected = isPosts;
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                IconButton(
  padding: EdgeInsets.only(left: 0), // No padding on the left to push it to the edge
  icon: Icon(Icons.menu, color: Colors.white),
  onPressed: _toggleDrawer,
),

                  Spacer(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _selectTab(true), // Set the state to show posts
                        child: Text(
                          'Posts',
                          style: TextStyle(
                            color: _isPostsSelected ? Color(0xFFF46AA0) : Colors.white, // Pink for selected, white for unselected
                            fontWeight: _isPostsSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () => _selectTab(false), // Set the state to show saved
                        child: Text(
                          'Saved',
                          style: TextStyle(
                            color: !_isPostsSelected ? Color(0xFFF46AA0) : Colors.white, // Pink for selected, white for unselected
                            fontWeight: !_isPostsSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.refresh, color: Colors.white), // White icon color
                        onPressed: _refreshPosts,
                      ),
                      IconButton(
                        icon: Icon(Icons.message, color: Colors.white), // Changed from send to message icon
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: _isPostsSelected ? _buildPostsContent() : _buildSavedContent(), // Change content based on selected tab
        
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
                  decoration: BoxDecoration(
                    color: Color(0xFF1C1C1C), // Darker color for post background
                    borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                    border: Border.all(color: Colors.grey.shade700, width: 1),
                  ),
                  child: ListTile(
                    tileColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // Consistent padding within the post
                    title: Text(
                      username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          data['content'],
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                        SizedBox(height: 8), // Slightly reduced spacing
                        // New icon row similar to Reddit's layout
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _buildIconText(
                                  icon: Icons.arrow_upward_rounded,
                                  text: data['upvotes'].toString(),
                                  color: Colors.pinkAccent,
                                  onTap: () {
                                    // Implement upvote functionality
                                  },
                                ),
                                SizedBox(width: 20),
                                _buildIconText(
                                  icon: Icons.arrow_downward_rounded,
                                  text: '',
                                  color: Colors.pinkAccent,
                                  onTap: () {
                                    // Implement downvote functionality
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _buildIconText(
                                  icon: Icons.comment,
                                  text: data['comments'].isNotEmpty ? data['comments'].length.toString() : '0',
                                  color: Colors.pinkAccent,
                                  onTap: () {
                                    _showComments(doc.id); // Call the _showComments function with the post ID
                                  },
                                ),
                                SizedBox(width: 20),
                                _buildIconText(
                                  icon: Icons.share,
                                  text: '',
                                  color: Colors.pinkAccent,
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
}
