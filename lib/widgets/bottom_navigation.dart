import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavigation({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  void showAddPostDialog(BuildContext context) {
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
                    'username': username,
                  };
                  await FirebaseFirestore.instance
                      .collection('communities')
                      .doc('communityId') // Use the correct communityId
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allow the floating button to overlap the navigation bar
      children: [
        Container(
          height: 80, // Keep this value consistent
          decoration: BoxDecoration(
            color: Color(0xFF011E3D), // Dark blue background for the nav bar
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', 0),
              _buildNavItem(Icons.calendar_today_outlined, 'Calendar', 1),
              SizedBox(width: 60), // This is the gap for the floating button
              _buildNavItem(Icons.people_outline, 'Community', 2),
              _buildNavItem(Icons.person_outline, 'Account', 3),
            ],
          ),
        ),
        Positioned(
          bottom: 40, // Adjust this value to float the button above the nav bar
          left: MediaQuery.of(context).size.width / 2 - 30, // Center the button
          child: FloatingActionButton(
            onPressed: () => showAddPostDialog(context), // Open the post creation dialog
            backgroundColor: Color.fromARGB(208, 13, 15, 41), // Pink color for the floating button
            child: Icon(Icons.add, size: 28, color: Color.fromARGB(255, 119, 3, 70)), // Plus icon
            elevation: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Color(0xFFF46AA0) // Highlighted pink color for selected
                  : Colors.transparent,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 24,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
