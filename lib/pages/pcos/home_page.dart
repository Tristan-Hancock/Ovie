import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = 'User';

  // For Today's Log checkboxes
  bool _isMenstruationChecked = false;
  bool _isCrampsChecked = false;
  bool _isSymptom1Checked = false;
  bool _isSymptom2Checked = false;

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
      backgroundColor: Color(0xFFF4F5FA), // Light background color
      appBar: AppBar(
        backgroundColor: Color(0xFFBBBFFE), // AppBar color from Figma design
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi $_username!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            Text(
              "Your ------ journey starts here. Let's go!",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Placeholder for more actions
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Did you know?" section
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE6E8), // Light red/pink background
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Did you know?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'PCOS is the most common hormonal disorder affecting women of reproductive age.',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Haven\'t taken the PCOS screening test yet?',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      'Start screening',
                      style: TextStyle(fontSize: 14, color: Colors.pinkAccent, decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Today's log section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s log',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_alt_outlined, color: Colors.black),
                    onPressed: () {
                      // Filter options
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  _buildCheckbox('Menstruation', _isMenstruationChecked, (val) {
                    setState(() {
                      _isMenstruationChecked = val!;
                    });
                  }),
                  _buildCheckbox('Cramps', _isCrampsChecked, (val) {
                    setState(() {
                      _isCrampsChecked = val!;
                    });
                  }),
                  _buildCheckbox('Symptom 1', _isSymptom1Checked, (val) {
                    setState(() {
                      _isSymptom1Checked = val!;
                    });
                  }),
                  _buildCheckbox('Symptom 2', _isSymptom2Checked, (val) {
                    setState(() {
                      _isSymptom2Checked = val!;
                    });
                  }),
                ],
              ),
              SizedBox(height: 20),
              // I feel section
              Text(
                'I feel',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildEmotionIcon('Smiling', 'assets/icons/smiling.png'), // Placeholder for PNG
                  _buildEmotionIcon('Neutral', 'assets/icons/neutral.png'),  // Placeholder for PNG
                  _buildEmotionIcon('Frowning', 'assets/icons/frowning.png'), // Placeholder for PNG
                  _buildEmotionIcon('Pouting', 'assets/icons/pouting.png'),  // Placeholder for PNG
                ],
              ),
              SizedBox(height: 20),
              // Capture your day
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Capture your day. Upload a selfie!',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build each checkbox for Today's Log
  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.pinkAccent,
      checkColor: Colors.white,
    );
  }

  // Function to build emotion icons with their label
  Widget _buildEmotionIcon(String label, String assetPath) {
    return Column(
      children: [
        Image.asset(assetPath, width: 40, height: 40), // Placeholder for emotion PNGs
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.black)),
      ],
    );
  }
}
