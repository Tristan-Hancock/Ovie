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

}


 @override
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: const Color(0xFF1E2749),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Emotions and Text Input
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Log your emotions" Text
              Text(
                'Log your emotions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8.0),

              // Emotion Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildEmotionIcon('Smiling', 'assets/icons/smiling.png'),
                  const SizedBox(width: 12),
                  _buildEmotionIcon('Neutral', 'assets/icons/neutral.png'),
                  const SizedBox(width: 12),
                  _buildEmotionIcon('Frowning', 'assets/icons/frowning.png'),
                  const SizedBox(width: 12),
                  _buildEmotionIcon('Pouting', 'assets/icons/pouting.png'),
                ],
              ),
              const SizedBox(height: 16.0),

              // "Write your thoughts" Text Box
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

              // Save Log Button
              Center(
                child: ElevatedButton(
                  onPressed: _logForToday,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBBBFFE),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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
        ),

        const SizedBox(width: 16.0), // Spacing between columns

        // Right Column: Image Capture
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // "Capture your day" Text
              Text(
                'Capture your day.\nUpload a selfie!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16.0),

              // Image Picker
              GestureDetector(
  onTap: _pickImage,
  child: Container(
    width: 200.0,
    height: 250.0,
    decoration: BoxDecoration(
      color: const Color(0xFF2A3557),
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(color: Colors.grey),
    ),
    child: _imagePath == null
        ? const Icon(Icons.camera_alt, color: Colors.grey, size: 28)
        : Stack(
            children: [
              // Display the uploaded image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.file(
                  File(_imagePath!),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Add the camera icon on the top-right corner
              Positioned(
                top: 8.0,
                right: 8.0,
                child: GestureDetector(
                  onTap: _pickImage, // Allow user to replace the image
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8), // Background for visibility
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
  ),
)

            ],
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
      width: 35, // Reduced container size for better spacing
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? const Color(0xFFBBBFFE) : Colors.grey[800],
        border: Border.all(
          color: isSelected ? Colors.white : Colors.transparent,
          width: 2.0,
        ), // Add border for selected state
      ),
      child: Center(
        child: Image.asset(
          assetPath,
          width: 34, // Reduced icon size
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}


}
