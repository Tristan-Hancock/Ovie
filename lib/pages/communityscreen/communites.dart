import 'package:flutter/material.dart';
import 'package:ovie/widgets/background_gradient.dart';
import 'package:ovie/pages/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isDrawerOpen = false;
  String _selectedCommunity = 'My Communities';
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
                await FirebaseFirestore.instance.collection('posts').add({
                  'content': _postController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                  'upvotes': 0,
                  'comments': [],
                  'replies': [],
                  'saved': false,
                  'userId': user.uid,
                  'username': user.displayName ?? 'Anonymous',
                });
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
            _buildDrawer(),
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
      return ListView(
        children: snapshot.data!.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // Check if 'content' exists in the document data
          if (!data.containsKey('content')) {
            return Container(); // Skip this document if 'content' field is missing
          }
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['username'] ?? 'Unknown', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(data['content']),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(icon: Icon(Icons.thumb_up), onPressed: () {}),
                          SizedBox(width: 5),
                          Text(data['upvotes'].toString()), // Upvotes count
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(icon: Icon(Icons.comment), onPressed: () {}),
                          SizedBox(width: 5),
                          Text(data['comments'] != '' ? '1' : '0'), // Comments count
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(icon: Icon(Icons.save), onPressed: () {}),
                          SizedBox(width: 5),
                          Text(data['saved'] ? '1' : '0'), // Saves count
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}



  Widget _buildSavedContent() {
    return Center(child: Text('Saved Content')); // Replace with actual saved content
  }

  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(-250 * (1 - _animationController.value), 0),
          child: BackgroundGradient(
            child: Container(
              width: 250,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DropdownButton<String>(
                            value: _selectedCommunity,
                            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                            dropdownColor: Color.fromARGB(255, 252, 208, 208),
                            underline: Container(
                              height: 2,
                              color: Colors.transparent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCommunity = newValue!;
                              });
                            },
                            items: <String>['My Communities', 'All Communities']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(16.0),
                        children: _selectedCommunity == 'My Communities'
                            ? [
                                _buildCommunityItem('Safe sex'),
                              ]
                            : [
                                _buildCommunityItem('Menstrual Cycle'),
                                _buildCommunityItem('Safe sex'),
                                _buildCommunityItem('Birth Control'),
                                _buildCommunityItem('Cramps'),
                                _buildCommunityItem('Puberty'),
                              ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommunityItem(String communityName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        communityName,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
