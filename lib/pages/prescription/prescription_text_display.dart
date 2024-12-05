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

class _PrescriptionTextDisplayDialogState
    extends State<PrescriptionTextDisplayDialog> {
  late TextEditingController _titleController;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.existingPrescription?.title ?? 'New Prescription');
    _textController =
        TextEditingController(text: widget.existingPrescription?.extractedText ?? widget.extractedText);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _savePrescription() {
    final title = _titleController.text.trim();
    final text = _textController.text.trim();

    if (title.isEmpty || text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and text cannot be empty!")),
      );
      return;
    }

    final prescription = Prescription(
      id: widget.existingPrescription?.id ?? 0,
      title: title,
      extractedText: text,
      scanDate: DateTime.now(),
    );

    widget.objectBox.prescriptionBox.put(prescription); // Save to ObjectBox
    widget.onSaved(); // Callback to update the list

    Navigator.of(context).pop(); // Close dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Prescription saved successfully!")),
    );
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
              controller: _textController,
              maxLines: 5,
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
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
