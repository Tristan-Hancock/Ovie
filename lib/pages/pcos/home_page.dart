import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovie/pages/pcos/logging.dart';
import 'package:ovie/services/objectbox.dart';

class HomePage extends StatefulWidget {
  final ObjectBox objectBox;

  HomePage({required this.objectBox});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = 'User';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _username = userDoc['username'] ?? 'User';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF101631), // Dark navy background
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.18), // Adjust AppBar height
        child: Container(
          color: const Color(0xFFBBBFFE), // Lavender background
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align greeting to the left
              children: [
                // Row for Icon and Ovelia Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align icon left, title center
                  children: [
                    // Icon on the left
                    Image.asset(
                      'assets/icons/ovelia.png', // Icon for Ovelia
                      width: 47, // Icon width
                      height: 47, // Icon height
                      fit: BoxFit.contain,
                    ),
                    // Ovelia title in the center
                    Expanded(
                      child: Text(
                        'Ovelia',
                        textAlign: TextAlign.center, // Center the title text
                        style: TextStyle(
                          fontSize: screenHeight * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Spacing between title and greeting
                // Greeting Section
                Text(
                  'Hi $_username!',
                  style: TextStyle(
                    fontSize: screenHeight * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Black for contrast
                    fontFamily: 'Quicksand',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Your PCOS journey starts here. Let's go!",
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    color: Colors.black87, // Slightly lighter black
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Daily Logging Section
                LoggingSection(objectBox: widget.objectBox),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
