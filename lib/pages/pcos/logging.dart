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
                fontSize: 18,
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildEmotionIcon('Smiling', 'assets/icons/smiling.png'),
            _buildEmotionIcon('Neutral', 'assets/icons/neutral.png'),
            _buildEmotionIcon('Frowning', 'assets/icons/frowning.png'),
            _buildEmotionIcon('Pouting', 'assets/icons/pouting.png'),
          ],
        ),
        SizedBox(height: 20),
        _buildCaptureSelfie(),
      ],
    );
  }

  // Function to build each checkbox for Today's Log
  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
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
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }

  // Function to build capture your day section
  Widget _buildCaptureSelfie() {
    return Container(
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
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
