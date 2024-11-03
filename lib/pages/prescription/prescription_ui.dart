import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String _extractedText = "Upload your prescriptions here to see the text.";
  bool _isImageUploaded = false;
  List<Prescription> _savedPrescriptions = [];

  @override
  void initState() {
    super.initState();
    _loadSavedPrescriptions(); // Load saved prescriptions on initialization
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
        _isImageUploaded = true;
      });
      _extractTextFromImage();
    }
  }

  Future<void> _extractTextFromImage() async {
    if (_selectedImage == null) return;

    try {
      String text = await PrescriptionService.extractPrescriptionText(_selectedImage!);
      setState(() {
        _extractedText = text.isNotEmpty ? text : "No readable text found.";
      });
    } catch (e) {
      setState(() {
        _extractedText = "An error occurred while extracting text.";
      });
    }
  }

  void _openPrescription() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrescriptionTextDisplay(
          text: _extractedText,
          objectBox: widget.objectBox,
          onSaved: _onPrescriptionSaved, // Pass the callback function
        ),
      ),
    );
  }

  void _onPrescriptionSaved() {
    _loadSavedPrescriptions(); // Refresh the list when a prescription is saved
  }

  void _viewSavedPrescription(Prescription prescription) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrescriptionTextDisplay(
          text: prescription.extractedText,
          objectBox: widget.objectBox,
          onSaved: _onPrescriptionSaved, // Ensure onSaved is passed here if required
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101631),
      appBar: AppBar(
        backgroundColor: Color(0xFF101631),
        automaticallyImplyLeading: false,
        title: Text(
          'Prescription Reader',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Upload your prescriptions here',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFBBBFFE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Upload Picture'),
            ),
            SizedBox(height: 20),
            if (_isImageUploaded)
              ElevatedButton(
                onPressed: _openPrescription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBBBFFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Open Prescription'),
              ),
            SizedBox(height: 30),
            Text(
              'Saved Prescriptions',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _savedPrescriptions.length,
                itemBuilder: (context, index) {
                  final prescription = _savedPrescriptions[index];
                  return Card(
                    color: Color(0xFF1A1E39),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        prescription.title,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Scanned on: ${prescription.scanDate}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      onTap: () => _viewSavedPrescription(prescription),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
