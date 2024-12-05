import 'package:flutter/material.dart';
import 'package:ovie/services/models.dart';
import '../../services/objectbox.dart';

class PrescriptionTextDisplayDialog extends StatefulWidget {
  final ObjectBox objectBox;
  final Prescription? existingPrescription; // Optional for editing
  final VoidCallback onSaved; // Callback to refresh the list
  final String extractedText;

  const PrescriptionTextDisplayDialog({
    Key? key,
    required this.objectBox,
    required this.onSaved,
    required this.extractedText,
    this.existingPrescription,
  }) : super(key: key);

  @override
  _PrescriptionTextDisplayDialogState createState() =>
      _PrescriptionTextDisplayDialogState();
}

class _PrescriptionTextDisplayDialogState extends State<PrescriptionTextDisplayDialog> {
  late TextEditingController _titleController;
  late TextEditingController _frequencyController;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _frequencyController = TextEditingController();
    _textController = TextEditingController(text: widget.extractedText);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _frequencyController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _savePrescription() {
    final title = _titleController.text.trim();
    final frequency = _frequencyController.text.trim();
    final extractedText = _textController.text.trim();

    if (title.isEmpty || extractedText.isEmpty || frequency.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    final prescription = Prescription(
      title: title,
      extractedText: extractedText,
      scanDate: DateTime.now(),
      frequency: frequency,
    );

    widget.objectBox.prescriptionBox.put(prescription); // Save prescription to ObjectBox
    widget.onSaved(); // Refresh the list in PrescriptionReader

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Prescription saved successfully!")),
    );

    Navigator.of(context).pop(); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: const Color(0xFF1A1E39),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Prescription Title",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF101631),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Frequency Input
            TextField(
              controller: _frequencyController,
              decoration: InputDecoration(
                labelText: "Frequency (e.g., 2 times a day)",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF101631),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Extracted Text Input
            TextField(
              controller: _textController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: "Prescription Text",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF101631),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Save Button
            ElevatedButton(
              onPressed: _savePrescription,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBBBFFE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

