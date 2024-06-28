import 'package:flutter/material.dart';
import 'package:ovie/widgets/background_gradient.dart';
import 'package:ovie/pages/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'communitymenu.dart';
class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isDrawerOpen = false;
  String _selectedCommunity = 'Your Communities';
  bool _isPostsSelected = true; // Add this variable to track the selected tab
  late Future<QuerySnapshot> _postsFuture;

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
                backgroundColor: Color.fromARGB(255, 252, 208, 208),
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.black),
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
                              color: _isPostsSelected ? Colors.black : Colors.grey, // Highlight selected tab
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
                              color: !_isPostsSelected ? Colors.black : Colors.grey, // Highlight selected tab
                              fontWeight: !_isPostsSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          icon: Icon(Icons.refresh, color: Colors.black),
                          onPressed: _refreshPosts,
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.black),
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
              floatingActionButton: FloatingActionButton(
                onPressed: _showAddPostDialog,
                child: Icon(Icons.add),
                backgroundColor: const Color.fromARGB(255, 248, 207, 221),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No posts available.'));
      }

      print("Fetched ${snapshot.data!.docs.length} posts"); // Print statement

      return ListView(
        padding: EdgeInsets.zero,
        children: snapshot.data!.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          print("Post data: $data"); // Print statement

          // Check if 'content' exists in the document data
          if (!data.containsKey('content')) {
            print("Skipping post with missing content field: ${doc.id}"); // Print statement
            return Container(); // Skip this document if 'content' field is missing
          }

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(data['userId']).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasError) {
                return Center(child: Text('Error: ${userSnapshot.error}'));
              }
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Center(child: Text('User not found'));
              }

              Map<String, dynamic> userData = userSnapshot.data!.data() as Map<String, dynamic>;
              String username = userData['username'] ?? 'Anonymous';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color.fromARGB(255, 255, 255, 255)), // Add bottom border here
                    ),
                  ),
                  child: ListTile(
                    tileColor: Colors.transparent, // Make background transparent
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                    title: Text(
                      username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          data['content'],
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Add upvote functionality here
                                  },
                                  child: Image.asset(
                                    'assets/images/upvote.png',
                                    height: 20.0,
                                    width: 20.0,
                                  ),
                                ),
                                SizedBox(width: 3), // Adjust space here
                                Text(
                                  data['upvotes'].toString(),
                                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ],
                            ),
                            SizedBox(width: 15), // Adjust space between icon sets here
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Add comment functionality here
                                  },
                                  child: Image.asset(
                                    'assets/images/chaticon.png',
                                    height: 20.0,
                                    width: 20.0,
                                  ),
                                ),
                                SizedBox(width: 3), // Adjust space here
                                Text(
                                  data['comments'].isNotEmpty ? '1' : '0',
                                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                ),
                              ],
                            ),
                            SizedBox(width: 15), // Adjust space between icon sets here
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print('send messsage click');
                                  },
                                  child: Image.asset(
                                    'assets/images/sendtoDM.png',
                                    height: 20.0,
                                    width: 20.0,
                                  ),
                                ),
                                SizedBox(width: 3), // Adjust space here
                                Text(
                                  data['saved'] ? '1' : '0',
                                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
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


  Widget _buildSavedContent() {
    return Center(child: Text('Saved Content')); // Replace with actual saved content
  }

  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
