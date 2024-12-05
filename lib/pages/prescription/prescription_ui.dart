import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ovie/pages/prescription/prescription_details.dart';
import 'dart:io';
import 'prescription_service.dart';
import 'prescription_text_display.dart';
import 'package:ovie/services/objectbox.dart';
import 'package:ovie/services/models.dart';

class PrescriptionReader extends StatefulWidget {
  final ObjectBox objectBox;

  const PrescriptionReader({Key? key, required this.objectBox}) : super(key: key);

  @override
  _PrescriptionReaderState createState() => _PrescriptionReaderState();
}

class _PrescriptionReaderState extends State<PrescriptionReader> {
  File? _selectedImage;
  String _extractedText = "No text extracted yet.";
  List<Prescription> _savedPrescriptions = [];

  @override
  void initState() {
    super.initState();
    _loadSavedPrescriptions();
  }

  Future<void> _loadSavedPrescriptions() async {
    setState(() {
      _savedPrescriptions = widget.objectBox.getAllPrescriptions();
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _extractedText = "Extracting text...";
      });
      await _extractTextFromImage();
    }
  }

  Future<void> _extractTextFromImage() async {
    if (_selectedImage == null) return;

    try {
      String text = await PrescriptionService.extractPrescriptionText(_selectedImage!);
      setState(() {
        _extractedText = text.isNotEmpty ? text : "No readable text found.";
      });
      _showPrescriptionDialog(); // Show dialog after extraction
    } catch (e) {
      setState(() {
        _extractedText = "An error occurred while extracting text.";
      });
    }
  }

void _showPrescriptionDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return PrescriptionTextDisplayDialog(
        objectBox: widget.objectBox,
        extractedText: _extractedText,
        onSaved: _loadSavedPrescriptions,
      );
    },
  );
}

void _deletePrescription(Prescription prescription) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Prescription'),
      content: const Text('Are you sure you want to delete this prescription?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.objectBox.prescriptionBox.remove(prescription.id);
            _loadSavedPrescriptions(); // Refresh the list
            Navigator.of(context).pop(); // Close dialog
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Prescription deleted successfully!'),
            ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFBBBFFE),
          ),
          child: const Text('Delete', style: TextStyle(color: Colors.black)),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101631),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101631),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/ovelia.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              'Medication Tracker',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Upload your prescriptions here',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Current Medication',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
  Expanded(
  child: ListView.builder(
    itemCount: _savedPrescriptions.length,
    itemBuilder: (context, index) {
      final prescription = _savedPrescriptions[index];
      return Card(
        color: const Color(0xFF1A1E39),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            prescription.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            prescription.frequency ?? "No frequency set",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'delete') {
                _deletePrescription(prescription);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrescriptionDetailsPage(
                  prescription: prescription,
                  objectBox: widget.objectBox,
                ),
              ),
            );
          },
        ),
      );
    },
  ),
),





          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBBBFFE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTimeButton(String time) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFBBBFFE),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      time,
      style: const TextStyle(color: Colors.black, fontSize: 14),
    ),
  );
}

}
