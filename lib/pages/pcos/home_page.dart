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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _username = userDoc['username'] ?? 'User';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101631), // Dark background color
 appBar: PreferredSize(
  preferredSize: Size.fromHeight(100), // Adjust the height for the app bar
  child: AppBar(
    backgroundColor: Color(0xFFBBBFFE), // AppBar background color from Figma design
    elevation: 0,
    automaticallyImplyLeading: false,
    flexibleSpace: Stack(
      children: [
        // Logo, Username and Greeting text
        Positioned(
          left: 16,
          top: 40, // Align with the logo and username at the same top position
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Image.asset(
                'assets/icons/ovelia2.png', // Logo asset
                height: 40,
                width: 40,
              ),
              SizedBox(height: 8), // Space between logo and greeting
              // Greeting text with the username
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get(), // Fetch the user's document from Firestore
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Hi User!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                        ));
                  }
                  if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                    return Text('Hi User!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                        ));
                  }

                  Map<String, dynamic>? userData = snapshot.data!.data() as Map<String, dynamic>?;
                  String username = userData?['username'] ?? 'User';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi $username!', // Username greeting
                        style: TextStyle(
                          fontSize: 28,
                         fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                        ),
                      ),
                      Text(
                        "Your journey starts here. Let's go!",
                        style: TextStyle(
                          fontSize: 14,
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
        // Ovelia in the top center
        Positioned(
          top: 40, // Align with the logo at the same top position
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Ovelia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'Quicksand',
              ),
            ),
          ),
        ),
        // 3 dots menu on the right
        Positioned(
          right: 16,
          top: 40, // Align the 3 dots at the same top position
          child: IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Placeholder for more actions
              
            },
          ),
        ),
      ],
    ),
  ),
),

  

     body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Did you know?" section ADD BACK LATER THIS IS FOR PRESENRATION 
        // Container(
        //   padding: EdgeInsets.all(16.0),
        //   decoration: BoxDecoration(
        //     color: Color(0xFFFFE6E8), // Light red/pink background
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Did you know?',
        //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        //       ),
        //       SizedBox(height: 8),
        //       Text(
        //         'PCOS is the most common hormonal disorder affecting women of reproductive age.',
        //         style: TextStyle(fontSize: 14, color: Colors.black),
        //       ),
        //       SizedBox(height: 8),
        //       Text(
        //         'Haven\'t taken the PCOS screening test yet?',
        //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(height: 16), // Add some space between the container and the button

        // Start Screening Button
      Center(
  child: ElevatedButton(
    onPressed: () {
      // Define your button action to navigate to the PCOS Screening Test
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScreeningTestPage()),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFBBBFFE), // Button color to match the app bar
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
      ),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust padding for button size
    ),
    child: Text(
      'Start Screening',
      style: TextStyle(
        fontSize: 16,
        color: const Color.fromARGB(255, 9, 9, 9), // Text color and size
      ),
    ),
  ),
),

        
        SizedBox(height: 20), // Space between the button and the LoggingSection
        LoggingSection(objectBox: widget.objectBox), // Logging Section
      ],
    ),
  ),
),

    );
  }

  
}
