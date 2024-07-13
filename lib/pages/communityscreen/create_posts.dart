import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void showAddPostDialog(BuildContext context, String communityId) {
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
                // Fetch the user's profile from Firestore
                DocumentSnapshot userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get();
                
                // Check if the user document exists and has a username
                String username = 'Anonymous';
                if (userDoc.exists && userDoc.data() != null) {
                  var userData = userDoc.data() as Map<String, dynamic>;
                  if (userData.containsKey('username')) {
                    username = userData['username'];
                  }
                }

                var postData = {
                  'content': _postController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                  'upvotes': 0,
                  'comments': [],
                  'replies': [],
                  'saved': false,
                  'userId': user.uid,
                  'username': username, // Use the fetched username
                };
                print("Adding post data: $postData"); // Print statement
                await FirebaseFirestore.instance
                    .collection('communities')
                    .doc(communityId)
                    .collection('posts')
                    .add(postData);
                Navigator.of(context).pop();
              }
            },
            child: Text('Post'),
          ),
        ],
      );
    },
  );
}
