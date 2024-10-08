import 'package:flutter/material.dart';

class LoggingSection extends StatefulWidget {
  @override
  _LoggingSectionState createState() => _LoggingSectionState();
}

class _LoggingSectionState extends State<LoggingSection> {
  // Today's Log checkboxes
  bool _isMenstruationChecked = false;
  bool _isCrampsChecked = false;
  bool _isSymptom1Checked = false;
  bool _isSymptom2Checked = false;

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
    // 'I feel' section
// 'I feel' section
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
        Image.asset(assetPath, width: 40, height: 40), // Adjust icon size
        SizedBox(height: 8),
        // Text(label, style: TextStyle(fontSize: 12, color: Colors.white)), // Smaller text size
      ],
    );
  }


Widget _buildCaptureSelfie() {
  return Container(
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
        Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey),
        SizedBox(height: 10),
        Text(
          'Capture your day.\nUpload a selfie!',
          textAlign: TextAlign.center, // Align the text in the center
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ],
    ),
  );
}

}
