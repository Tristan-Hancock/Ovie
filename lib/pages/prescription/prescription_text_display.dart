import 'package:flutter/material.dart';

class PrescriptionTextDisplay extends StatelessWidget {
  final String text;

  const PrescriptionTextDisplay({Key? key, required this.text}) : super(key: key);

  void _savePrescription() {
    // Add save logic here, e.g., saving to local storage or database
    print("Prescription saved!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Extracted Prescription',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF101631),
      ),
      backgroundColor: Color(0xFF101631),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Text(
                text,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _savePrescription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBBBFFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Save'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
