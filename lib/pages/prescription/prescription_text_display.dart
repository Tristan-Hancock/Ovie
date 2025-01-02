import 'package:flutter/material.dart';
import '../../services/objectbox.dart';
import '../../services/models.dart';

class PrescriptionTextDisplayDialog extends StatefulWidget {
  final ObjectBox objectBox;
  final String extractedText;
  final VoidCallback onSaved;

  const PrescriptionTextDisplayDialog({
    Key? key,
    required this.objectBox,
    required this.extractedText,
    required this.onSaved,
  }) : super(key: key);

  @override
  _PrescriptionTextDisplayDialogState createState() =>
      _PrescriptionTextDisplayDialogState();
}

class _PrescriptionTextDisplayDialogState
    extends State<PrescriptionTextDisplayDialog> {
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

    if (title.isEmpty || frequency.isEmpty || extractedText.isEmpty) {
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

    widget.objectBox.prescriptionBox.put(prescription);
    widget.onSaved();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Prescription saved successfully!")),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: const Color(0xFF1A1E39),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.75, // Limit the height of the dialog
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
      ),
    );
  }
}
