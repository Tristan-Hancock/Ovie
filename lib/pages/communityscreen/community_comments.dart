import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommunityCommentsPage extends StatefulWidget {
  final String communityId;
  final String postId;

  const CommunityCommentsPage({Key? key, required this.communityId, required this.postId}) : super(key: key);

  @override
  _CommunityCommentsPageState createState() => _CommunityCommentsPageState();
}

class _CommunityCommentsPageState extends State<CommunityCommentsPage> {
  TextEditingController _commentController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isKeyboardVisible = _focusNode.hasFocus;
      });
    });
  }

  Future<void> _addComment() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _commentController.text.isNotEmpty) {
      // Fetch the user's username from the 'users' collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String username = userDoc['username'] ?? 'Anonymous';

      var commentData = {
        'content': _commentController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'username': username,
      };
      await FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.communityId)
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add(commentData);
      _commentController.clear();
      _focusNode.unfocus(); // Hide the keyboard after adding a comment
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white, // White background to match the rest of the app
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              // Header: Comments Title and Close Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,  // Black for the title
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: Colors.black),
                    ),
                  ],
                ),
              ),
              // Comment List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('communities')
                      .doc(widget.communityId)
                      .collection('posts')
                      .doc(widget.postId)
                      .collection('comments')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.black)));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No comments yet', style: TextStyle(color: Colors.black)));
                    }

                    var comments = snapshot.data!.docs;

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        var comment = comments[index].data() as Map<String, dynamic>;
                        var timestamp = comment['timestamp'] != null
                            ? (comment['timestamp'] as Timestamp).toDate().toString()
                            : 'Just now';
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFFBBBFFE), // Updated avatar background to match theme
                                child: Text(
                                  comment['username'][0].toUpperCase(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          comment['username'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          timestamp,
                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      comment['content'],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () {
                                        // Implement reply functionality if needed
                                      },
                                      child: Text(
                                        'Reply',
                                        style: TextStyle(color: Color(0xFFF4608B), fontSize: 12), // Pink for the reply link
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.favorite_border, color: Colors.black, size: 16), // Changed heart color to black
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              // Comment Input Field and Send Button
              Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F0F0), // Light grey background for input
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: TextField(
                            controller: _commentController,
                            focusNode: _focusNode,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: Colors.black), // Updated text color to black
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Color(0xFFF4608B)), // Pink send button
                        onPressed: _addComment,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
