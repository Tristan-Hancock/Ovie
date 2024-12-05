import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovie/pages/pcos/logging.dart';
import 'package:ovie/pages/pcos/screening_test.dart';
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
      backgroundColor: const Color(0xFF101631),
      appBar: AppBar(
  backgroundColor: const Color(0xFFBBBFFE),
  elevation: 0,
  centerTitle: true, // Ensures the title is centered
  automaticallyImplyLeading: false, // Removes the default back button
  title: Text(
    'Ovelia',
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'Quicksand',
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
                const SizedBox(height: 16),
                // Greeting Section (Username and Subtitle)
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    String greetingText = 'Hi User!';
                    String subtitleText = "Your journey starts here. Let's go!";
                    if (snapshot.hasData && snapshot.data!.exists) {
                      Map<String, dynamic>? userData =
                          snapshot.data!.data() as Map<String, dynamic>?;
                      greetingText = 'Hi ${userData?['username'] ?? 'User'}!';
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greetingText,
                          style: TextStyle(
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Quicksand',
                          ),
                        ),
                        Text(
                          subtitleText,
                          style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Start Screening Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScreeningTestPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBBBFFE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.2,
                        vertical: screenHeight * 0.02,
                      ), // Adjust padding
                    ),
                    child: Text(
                      'Start Screening',
                      style: TextStyle(
                        fontSize: screenHeight * 0.02,
                        color: const Color(0xFF090909),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Logging Section
                LoggingSection(objectBox: widget.objectBox),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
