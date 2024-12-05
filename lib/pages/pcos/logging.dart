import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthUser;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ovie/objectbox.g.dart';
import 'package:ovie/services/models.dart' as UserModel;
import 'package:ovie/services/objectbox.dart';
import 'package:ovie/services/models.dart';
import 'dart:math';
class LoggingSection extends StatefulWidget {
  final ObjectBox objectBox;

  LoggingSection({required this.objectBox});

  @override
  _LoggingSectionState createState() => _LoggingSectionState();
}

class _LoggingSectionState extends State<LoggingSection> {
  bool _isMenstruationChecked = false;
  bool _isCrampsChecked = false;
  bool _isAcneChecked = false;
  bool _isHeadachesChecked = false;
  String _selectedEmotion = 'Smiling';
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final isSmallScreen = maxWidth < 360;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s log',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_alt_outlined, color: Colors.white),
                    onPressed: () {},
                    constraints: BoxConstraints.tightFor(width: 40, height: 40),
                  ),
                ],
              ),
            ),

            // Checkboxes Section
            Wrap(
              spacing: 4,
              runSpacing: 0,
              children: [
                _buildCheckbox('Menstruation', _isMenstruationChecked, (val) {
                  setState(() => _isMenstruationChecked = val!);
                }, maxWidth),
                _buildCheckbox('Cramps', _isCrampsChecked, (val) {
                  setState(() => _isCrampsChecked = val!);
                }, maxWidth),
                _buildCheckbox('Acne', _isAcneChecked, (val) {
                  setState(() => _isAcneChecked = val!);
                }, maxWidth),
                _buildCheckbox('Headaches', _isHeadachesChecked, (val) {
                  setState(() => _isHeadachesChecked = val!);
                }, maxWidth),
              ],
            ),

            const SizedBox(height: 16),

            // Emotion Section
            Text(
              'I feel',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 12),

            // Emotions Wrap
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildEmotionIcon('Smiling', 'assets/icons/smiling.png'),
                  _buildEmotionIcon('Neutral', 'assets/icons/neutral.png'),
                  _buildEmotionIcon('Frowning', 'assets/icons/frowning.png'),
                  _buildEmotionIcon('Pouting', 'assets/icons/pouting.png'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Selfie Section
            Center(
              child: Column(
                children: [
                  _buildCaptureSelfie(
                    min(maxWidth * 0.9, 300),
                    min(maxWidth * 0.9, 300),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: min(maxWidth * 0.9, 200),
                    child: ElevatedButton(
                      onPressed: _logForToday,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBBBFFE),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Log for Today'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged, double maxWidth) {
    return SizedBox(
      width: maxWidth < 400 ? maxWidth / 2 - 4 : maxWidth / 2 - 8,
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: maxWidth < 360 ? 12 : 14,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.pinkAccent,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        dense: true,
      ),
    );
  }

  Widget _buildEmotionIcon(String label, String assetPath) {
    bool isSelected = _selectedEmotion == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedEmotion = label;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: const Color(0xFFBBBFFE), width: 3)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset(
              assetPath,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureSelfie(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(12),
          child: _imagePath == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.camera_alt_outlined,
                        size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Capture your day.\nUpload a selfie!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_imagePath!),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  void _logForToday() {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    DailyLog log = DailyLog(
      date: currentDate,
      isMenstruation: _isMenstruationChecked,
      isCramps: _isCrampsChecked,
      isAcne: _isAcneChecked,
      isHeadaches: _isHeadachesChecked,
      emotion: _selectedEmotion,
      imagePath: _imagePath,
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
}