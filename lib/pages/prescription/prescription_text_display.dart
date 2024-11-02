import 'package:flutter/material.dart';
import 'package:ovie/services/models.dart';
import '../../services/objectbox.dart';

class PrescriptionTextDisplay extends StatelessWidget {
  final String text;
  final ObjectBox objectBox;

  const PrescriptionTextDisplay({Key? key, required this.text, required this.objectBox}) : super(key: key);

  void _savePrescription(BuildContext context, String title) {
    // Create a new Prescription entity with the entered title and extracted text
    final prescription = Prescription(
      title: title,
      extractedText: text, // Use 'extractedText' instead of 'content'
      scanDate: DateTime.now(),
    );

    // Save the prescription to ObjectBox
    objectBox.savePrescription(prescription);

    // Confirmation feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Prescription saved successfully!")),
    );
  }

  void _promptForTitle(BuildContext context) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enter Prescription Title"),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: "Prescription Title",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                Navigator.of(context).pop(); // Close the dialog
                _savePrescription(context, title); // Save with entered title
              } else {
                // Show an error if title is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Title cannot be empty!")),
                );
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
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
                onPressed: () => _promptForTitle(context), // Open title prompt
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
