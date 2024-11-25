import 'package:flutter/material.dart';
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
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  TextEditingController _tagsController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,  // Allows the bottom sheet to take up more space
    backgroundColor: Colors.transparent,  // Transparent background to match design
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color as per Figma
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          padding: EdgeInsets.all(16.0),  // Padding inside the bottom sheet
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,  // Minimize the height based on content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row with My Post Text and Search Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Post',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        // Implement search if necessary
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Title Field
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.black54),
                    hintText: 'Type here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Body Field
                TextField(
                  controller: _bodyController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Body',
                    labelStyle: TextStyle(color: Colors.black54),
                    hintText: 'Type here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Tags Field
                TextField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    labelText: 'Tags',
                    labelStyle: TextStyle(color: Colors.black54),
                    hintText: 'Type here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Post and Delete Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Post Button
                    ElevatedButton(
                      onPressed: () async {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          var postData = {
                            'title': _titleController.text,
                            'content': _bodyController.text,
                            'tags': _tagsController.text.split(','),
                            'timestamp': FieldValue.serverTimestamp(),
                            'upvotes': 0,
                            'comments': [],
                            'replies': [],
                            'saved': false,
                            'userId': user.uid,
                            'username': user.displayName ?? 'Anonymous',
                          };
                          print("Adding post data: $postData");
                          await FirebaseFirestore.instance.collection('posts').add(postData);
                          Navigator.of(context).pop();
                          _refreshPosts();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF4608B),  // Pink color from Figma
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: Text(
                        'Post',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    // Delete Button
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();  // Close bottom sheet on delete
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFF4608B)),  // Pink border
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Color(0xFFF4608B)),  // Pink text for delete
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
        child: Container(
          color: Color(0xFF101631), // Set solid background color
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(110), // Adjust height to accommodate tabs
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Drawer, "Community" text, and Search Icon
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Drawer Icon
                          IconButton(
                            icon: Icon(Icons.menu, color: Colors.white),
                            onPressed: _toggleDrawer, // Toggle drawer
                          ),
                          // Community Text
                          Text(
                            'Community',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          // Search Icon
                          IconButton(
                            icon: Icon(Icons.search, color: Colors.white),
                            onPressed: () {
                              // Implement search functionality here
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10), // Spacing between the title and tabs

                    // Posts and Chats Toggle Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _selectTab(true, false), // When 'Posts' is selected
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                color: _isPostsSelected ? Color(0xFFBBBFFE) : Colors.transparent, // Highlight Posts when selected
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Posts',
                                style: TextStyle(
                                  color: _isPostsSelected ? Colors.white : Colors.grey,
                                  fontWeight: _isPostsSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectTab(false, true), // When 'Chats' is selected
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                color: _isChatsSelected ? Color(0xFF7C5AEC) : Colors.transparent, // Highlight Chats when selected
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Chats',
                                style: TextStyle(
                                  color: _isChatsSelected ? Colors.white : Colors.grey,
                                  fontWeight: _isChatsSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: _isChatsSelected
                ? ChatScreen() // Show ChatScreen if Chats is selected
                : _isPostsSelected
                    ? _buildPostsContent() // Show Posts if selected
                    : _buildSavedContent(), // Show Saved content otherwise

            // Floating Action Button (Create Post Button)
            floatingActionButton: FloatingActionButton(
              onPressed: _showAddPostDialog,  // Use the function already written
              backgroundColor: Color(0xFFF4608B),  // Use the pink color from the Figma
              child: Text(
                'Write',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Positioned at the bottom-right
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
        return Center(
          child: Text(
            'Error: ${snapshot.error}',
            style: TextStyle(color: Colors.black), // Updated text color for error message
          ),
        );
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(
          child: Text(
            'No posts available.',
            style: TextStyle(color: Colors.black), // Updated text color for no posts message
          ),
        );
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
                return Center(
                  child: Text(
                    'Error: ${userSnapshot.error}',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Center(
                  child: Text(
                    'User not found',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }

              Map<String, dynamic> userData = userSnapshot.data!.data() as Map<String, dynamic>;
              String username = userData['username'] ?? 'Anonymous';

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Adjust spacing
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set post background to white
                    borderRadius: BorderRadius.circular(12), // Slightly rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2), // Adds subtle shadow for depth
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0), // Adjust padding for the post content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Placeholder for Avatar Image
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xFFBBBFFE), // Background for avatar
                              child: Text(username[0].toUpperCase()), // Display first letter of username
                            ),
                            SizedBox(width: 10),
                            Text(
                              username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16, // Match Figma text size
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.more_vert, color: Colors.grey),
                              onPressed: () {
                                // Open post options menu
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        // Post Title
                        Text(
                          data['title'] ?? 'Title goes here', // Placeholder title if none
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black, // Match Figma color
                          ),
                        ),
                        SizedBox(height: 4),
                        // Post Content
                        Text(
                          data['content'] ?? 'Post content goes here...',
                          style: TextStyle(
                            color: Colors.black54, // Lighter color for post content
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            _buildTag('Cramps'), // Example tag
                            SizedBox(width: 5),
                            _buildTag('PCOS'), // Another example tag
                          ],
                        ),
                        SizedBox(height: 8),
                        // Post Interactions (Upvote, Bookmark, Comment, Share)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _buildIconText(
                                  iconPath: 'assets/icons/like.png', // Placeholder for upvote icon
                                  text: data['upvotes'].toString(),
                                  onTap: () {
                                    // Implement upvote functionality
                                  },
                                ),
                                SizedBox(width: 20),
                                _buildIconText(
                                  iconPath: 'assets/icons/save.png', // Placeholder for bookmark icon
                                  text: '',
                                  onTap: () {
                                    // Implement bookmark functionality
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _buildIconText(
                                  iconPath: 'assets/icons/comments.png', // Placeholder for comment icon
                                  text: data['comments'].isNotEmpty ? data['comments'].length.toString() : '0',
                                  onTap: () {
                                    _showComments(doc.id); // Call the _showComments function with the post ID
                                  },
                                ),
                                // SizedBox(width: 20),
                                // _buildIconText(
                                //   iconPath: 'assets/icons/share.png', // Placeholder for share icon
                                //   text: '',
                                //   onTap: () {
                                //     // Implement share functionality
                                //   },
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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

// Widget to handle Tag UI
Widget _buildTag(String tagName) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Color(0xFFBBBFFE), // Updated tag background color
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      tagName,
      style: TextStyle(color: Colors.white, fontSize: 12),
    ),
  );
}

// Widget to handle Icon and Text (like Upvote, Bookmark, Comment, etc.)
Widget _buildIconText({
  required String iconPath,
  required String text,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        Image.asset(iconPath, height: 20), // Placeholder for custom icons
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
      ],
    ),
  );
}

// Widget _buildIconText({
//   required IconData icon,
//   required String text,
//   required VoidCallback onTap,
//   required Color color,
// }) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Row(
//       children: [
//         Icon(icon, color: color, size: 18), // Slightly smaller icon size
//         SizedBox(width: 3),
//         Text(
//           text,
//           style: TextStyle(color: color),
//         ),
//       ],
//     ),
//   );
// }
  Widget _buildSavedContent() {
    return Center(child: Text('No Saves Added')); // Replace with actual saved content
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }



  
   Widget _buildTabs() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust padding as needed
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _selectTab(true, false), // When 'Posts' is selected
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: _isPostsSelected ? Color(0xFF7C5AEC) : Colors.transparent, // Selected background color
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Posts',
              style: TextStyle(
                color: _isPostsSelected ? Colors.white : Colors.grey,
                fontWeight: _isPostsSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(width: 10), // Space between tabs
        GestureDetector(
          onTap: () => _selectTab(false, true), // When 'Chats' is selected
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: !_isPostsSelected ? Color(0xFF7C5AEC) : Colors.transparent, // Selected background color
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Chats',
              style: TextStyle(
                color: !_isPostsSelected ? Colors.white : Colors.grey,
                fontWeight: !_isPostsSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget _buildTag(String tagName) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//     decoration: BoxDecoration(
//       color: Color.fromARGB(255, 124, 90, 236), // Background for tag
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: Text(
//       tagName,
//       style: TextStyle(color: Colors.white, fontSize: 12),
//     ),
//   );
// }

}
