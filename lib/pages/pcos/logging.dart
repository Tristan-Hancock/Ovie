import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthUser;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ovie/objectbox.g.dart';
import 'package:ovie/services/models.dart' as UserModel;
import 'package:ovie/services/objectbox.dart';
import 'package:ovie/services/models.dart';

class LoggingSection extends StatefulWidget {
  final ObjectBox objectBox;

  LoggingSection({required this.objectBox});

  @override
  _LoggingSectionState createState() => _LoggingSectionState();
}

class _LoggingSectionState extends State<LoggingSection> {
  String _selectedEmotion = 'Smiling';
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textLogController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _logForToday() {
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  DailyLog log = DailyLog(
    date: currentDate,
    emotion: _selectedEmotion,
    imagePath: _imagePath,
    textlog: _textLogController.text,
    isMenstruation: false, // Default or user-provided value
    isCramps: false,       // Default or user-provided value
    isAcne: false,         // Default or user-provided value
    isHeadaches: false,    // Default or user-provided value
  );

  var user = widget.objectBox.userBox
          .query(User_.userId.equals(
              FirebaseAuthUser.FirebaseAuth.instance.currentUser!.uid))
          .build()
          .findFirst() ??
      UserModel.User(
          userId: FirebaseAuthUser.FirebaseAuth.instance.currentUser!.uid);

  if (user.id == 0) {
    widget.objectBox.userBox.put(user);
  }

  log.user.target = user;
  widget.objectBox.dailyLogBox.put(log);

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Log for $currentDate saved successfully!'),
  ));

  _textLogController.clear();
}


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2749),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Text(
                'Log your emotions',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Spacer(),
              Text(
                'Capture your day',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
  children: [
    Expanded(
      flex: 3,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Remove spaceBetween
          children: [
            _buildEmotionIcon('Smiling', 'assets/icons/smiling.png'),
            SizedBox(width: 8), // Add spacing between icons
            _buildEmotionIcon('Neutral', 'assets/icons/neutral.png'),
            SizedBox(width: 8),
            _buildEmotionIcon('Frowning', 'assets/icons/frowning.png'),
            SizedBox(width: 8),
            _buildEmotionIcon('Pouting', 'assets/icons/pouting.png'),
          ],
        ),
      ),
    ),
    const SizedBox(width: 8.0),
    Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            color: const Color(0xFF2A3557),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.grey),
          ),
          child: _imagePath == null
              ? Center(
                  child: Icon(Icons.camera_alt, color: Colors.grey),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(
                    File(_imagePath!),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    ),
  ],
),

          const SizedBox(height: 16.0),
          TextField(
            controller: _textLogController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write your thoughts...',
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF2A3557),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              onPressed: _logForToday,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBBBFFE),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Save Log',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionIcon(String label, String assetPath) {
    bool isSelected = _selectedEmotion == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEmotion = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? const Color(0xFFBBBFFE) : Colors.grey[800],
        ),
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          assetPath,
          width: 36,
          height: 36,
        ),
      ),
    );
  }
}
