import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovie/pages/pcos/logging.dart';
import 'package:ovie/pages/pcos/screening_test.dart';
import 'package:ovie/services/objectbox.dart';

class HomePage extends StatefulWidget {
  final ObjectBox objectBox; // ObjectBox instance
  
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
      backgroundColor: Color(0xFF101631), // Dark background color
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15), // Adjust height dynamically
        child: AppBar(
          backgroundColor: Color(0xFFBBBFFE), // AppBar background color
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Responsive padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/ovelia2.png', // Logo asset
                      height: screenHeight * 0.05, // Adjust size dynamically
                      width: screenHeight * 0.05,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Ovelia',
                      style: TextStyle(
                        fontSize: screenHeight * 0.025,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02), // Responsive spacing
                // Greeting text
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
                            color: Colors.black,
                            fontFamily: 'Quicksand',
                          ),
                        ),
                        Text(
                          subtitleText,
                          style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
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
                    backgroundColor: Color(0xFFBBBFFE), // Button color
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
                      color: Color(0xFF090909),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Logging Section
              LoggingSection(objectBox: widget.objectBox),
            ],
          ),
        ),
      ),
    );
  }
}
