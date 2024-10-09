import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart'; // Import only once
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ovie/objectbox.g.dart';
import 'package:ovie/services/models.dart';
import 'package:ovie/services/objectbox.dart';
import 'package:ovie/services/models.dart' as UserModel;
import 'package:image_picker/image_picker.dart';
class LoggingSection extends StatefulWidget {
  final ObjectBox objectBox; // ObjectBox instance

  LoggingSection({required this.objectBox}); // Accept ObjectBox instance

  @override
  _LoggingSectionState createState() => _LoggingSectionState();
}

class _LoggingSectionState extends State<LoggingSection> {
  // Today's Log checkboxes
  bool _isMenstruationChecked = false;
  bool _isCrampsChecked = false;
  bool _isAcneChecked = false;
  bool _isHeadachesChecked = false;
  String _selectedEmotion = 'Smiling'; // Default emotion
  String? _imagePath; // For selfie image path
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Today's Log section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s log',
              style: TextStyle(
                fontSize: 16, // Smaller font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_alt_outlined, color: Colors.white),
              onPressed: () {
                // Add filter functionality here if needed
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCheckbox('Acne', _isAcneChecked, (val) {
              setState(() {
                _isAcneChecked = val!;
              });
            }),
            _buildCheckbox('Headaches', _isHeadachesChecked, (val) {
              setState(() {
                _isHeadachesChecked = val!;
              });
            }),
          ],
        ),
        SizedBox(height: 20),

        // I feel section
        Text(
          'I feel',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4), // Reduce the height to move the icons closer to the label
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align the icons closer to the top
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Adjusts vertical positioning of the icons
              children: [
                _buildEmotionIcon('Smiling', 'assets/icons/smiling.png'),
                SizedBox(width: 8), // Adjust space between the icons
                _buildEmotionIcon('Neutral', 'assets/icons/neutral.png'),
                SizedBox(width: 8), // Adjust space between the icons
                _buildEmotionIcon('Frowning', 'assets/icons/frowning.png'),
                SizedBox(width: 8), // Adjust space between the icons
                _buildEmotionIcon('Pouting', 'assets/icons/pouting.png'),
              ],
            ),
            // Add the longer selfie capture section beside the icons
            _buildCaptureSelfie(),
          ],
        ),
        SizedBox(height: 20),
        // Log for today button
       ElevatedButton(
  onPressed: _logForToday, // Handle log submission
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFBBBFFE), // Match the app bar color
  ),
  child: Text('Log for Today'),
),

      ],
    );
  }

  // Function to build each checkbox for Today's Log
  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return Expanded(
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14), // Smaller text
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.pinkAccent,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading, // Align checkbox to the left of text
        contentPadding: EdgeInsets.zero, // Remove default padding
      ),
    );
  }

  // Function to build emotion icons with their label
  Widget _buildEmotionIcon(String label, String assetPath) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedEmotion = label; // Set the selected emotion
            });
          },
          child: Image.asset(assetPath, width: 40, height: 40), // Adjust icon size
        ),
        SizedBox(height: 8),
      ],
    );
  }
Future<void> _pickImage() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Use gallery for now
  if (pickedFile != null) {
    setState(() {
      _imagePath = pickedFile.path;
    });
  }
}

Widget _buildCaptureSelfie() {
  return GestureDetector(
    onTap: _pickImage, // Call function to pick an image
    child: Container(
      width: 150, // Adjust width to make it slightly wider
      height: 220, // Increased height to align with the top of the "I feel" text
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _imagePath == null
              ? Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey)
              : Image.file(
                  File(_imagePath!), // Show the selected image
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
          SizedBox(height: 10),
          Text(
            'Capture your day.\nUpload a selfie!',
            textAlign: TextAlign.center, // Align the text in the center
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}


  // Function to log today's data to ObjectBox
// Function to log today's data to ObjectBox
void _logForToday() {
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // Create a new daily log
  DailyLog log = DailyLog(
    date: currentDate,
    isMenstruation: _isMenstruationChecked,
    isCramps: _isCrampsChecked,
    isAcne: _isAcneChecked,
    isHeadaches: _isHeadachesChecked,
    emotion: _selectedEmotion,
    imagePath: _imagePath, // Handle the image path here
  );

  // Find or create a user entry for the current user in ObjectBox
  var user = widget.objectBox.userBox
      .query(User_.userId.equals(FirebaseAuth.instance.currentUser!.uid))
      .build()
      .findFirst() ?? UserModel.User(userId: FirebaseAuth.instance.currentUser!.uid);

  if (user.id == 0) {
    widget.objectBox.userBox.put(user); // Save user if not exists
  }

  // Link the log to the current user
  log.user.target = user;

  // Save the log to ObjectBox
  widget.objectBox.dailyLogBox.put(log);

  // Show success message with a SnackBar
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Log for $currentDate saved successfully!'),
  ));

  // Print log data for debugging
  print('--- Daily Log ---');
  print('Date: $currentDate');
  print('Menstruation: $_isMenstruationChecked');
  print('Cramps: $_isCrampsChecked');
  print('Acne: $_isAcneChecked');
  print('Headaches: $_isHeadachesChecked');
  print('Emotion: $_selectedEmotion');
  print('Image Path: $_imagePath');
}

}
