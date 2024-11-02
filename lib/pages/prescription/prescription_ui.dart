import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'prescription_service.dart';

class PrescriptionReader extends StatefulWidget {
  @override
  _PrescriptionReaderState createState() => _PrescriptionReaderState();
}

class _PrescriptionReaderState extends State<PrescriptionReader> {
  File? _selectedImage;
  String _extractedText = "Upload your prescriptions here to see the text.";

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _extractedText = "Extracting text...";
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
  } catch (e, stackTrace) {
    print("Error: $e");
    print("StackTrace: $stackTrace");  // Add stack trace to understand where it failed
    setState(() {
      _extractedText = "An error occurred while extracting text.";
    });
  }
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
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 200)
                : Container(),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _extractedText,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
