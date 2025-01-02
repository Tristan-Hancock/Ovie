import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovie/pages/pcos/logging.dart';
import 'package:ovie/pages/pcos/medication.dart';
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
                Stack(
                  alignment: Alignment.center, // Center the Ovelia title
                  children: [
                    // Icon on the left
                    Positioned(
                      left: 0,
                      child: Image.asset(
                        'assets/icons/ovelia.png', // Icon for Ovelia
                        width: 47, // Icon width
                        height: 47, // Icon height
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Center the Ovelia title
                    Center(
                      child: Text(
                        'Ovelia',
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
                          Text(
            'Today',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16.0),





                LoggingSection(objectBox: widget.objectBox),
                const SizedBox(height: 24), // Space between logging and medications
                const Text(
                  "Track Your Medications",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Add the MedicationSection here
                MedicationSection(objectBox: widget.objectBox),
                const SizedBox(height: 24), // Space between medications and button
                // Start Screening Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScreeningTestPage(), // Navigate to Screening Test
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBBBFFE), // Button color
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
                        color: const Color(0xFF090909), // Text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
