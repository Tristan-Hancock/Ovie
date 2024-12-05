import 'package:flutter/material.dart';
import 'package:ovie/services/models.dart';
import '../../services/objectbox.dart';

class PrescriptionTextDisplay extends StatefulWidget {
  final ObjectBox objectBox;
  final VoidCallback onSaved;
  final Prescription? existingPrescription; // Optional for editing
  final bool isEditing; // To distinguish between create and edit modes

  const PrescriptionTextDisplay({
    Key? key,
    required this.objectBox,
    required this.onSaved,
    this.existingPrescription,
    this.isEditing = false,
  }) : super(key: key);

  @override
  _PrescriptionTextDisplayState createState() =>
      _PrescriptionTextDisplayState();
}

class _PrescriptionTextDisplayState extends State<PrescriptionTextDisplay> {
  late TextEditingController _titleController;
  late TextEditingController _textController;
  late bool _isEditing; // Ensure this is marked as `late` since it's initialized in `initState`.

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEditing; // Initialize `_isEditing` here.

    // Initialize text controllers with existing data if available
    _titleController = TextEditingController(
      text: widget.existingPrescription?.title ?? '',
    );
    _textController = TextEditingController(
      text: widget.existingPrescription?.extractedText ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _saveOrUpdatePrescription() {
    final title = _titleController.text.trim();
    final text = _textController.text.trim();

    if (title.isEmpty || text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and text cannot be empty!")),
      );
      return;
    }

    final prescription = Prescription(
      id: widget.existingPrescription?.id ?? 0, // Use existing ID if editing
      title: title,
      extractedText: text,
      scanDate: widget.existingPrescription?.scanDate ?? DateTime.now(),
    );

    widget.objectBox.prescriptionBox.put(prescription); // Save or update
    widget.onSaved(); // Trigger the callback to refresh the list

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.existingPrescription != null
            ? "Prescription updated successfully!"
            : "Prescription saved successfully!"),
      ),
    );

    Navigator.of(context).pop(); // Go back after saving
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
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
          _isEditing ? 'Edit Prescription' : 'View Prescription',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF101631),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: _toggleEditMode,
            ),
        ],
      ),
      backgroundColor: Color(0xFF101631),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              enabled: _isEditing,
              decoration: InputDecoration(
                labelText: "Prescription Title",
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Color(0xFF1A1E39),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _textController,
                enabled: _isEditing,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  labelText: "Prescription Text",
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xFF1A1E39),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (_isEditing)
              ElevatedButton(
                onPressed: _saveOrUpdatePrescription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBBBFFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Save'),
              ),
          ],
        ),
      ),
    );
  }
}
