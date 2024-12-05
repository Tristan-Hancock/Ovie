import 'package:flutter/material.dart';
import 'package:ovie/services/models.dart';
import 'package:ovie/services/objectbox.dart';

class PrescriptionDetailsPage extends StatefulWidget {
  final Prescription prescription;
  final ObjectBox objectBox;

  const PrescriptionDetailsPage({
    Key? key,
    required this.prescription,
    required this.objectBox,
  }) : super(key: key);

  @override
  _PrescriptionDetailsPageState createState() => _PrescriptionDetailsPageState();
}

class _PrescriptionDetailsPageState extends State<PrescriptionDetailsPage> {
  late TextEditingController _doseController;
  late TextEditingController _frequencyController;

  @override
  void initState() {
    super.initState();
    _doseController = TextEditingController(
        text: widget.prescription.extractedText ?? "Enter prescription details here");
    _frequencyController = TextEditingController(text: "2 times a day"); // Placeholder value
  }

  @override
  void dispose() {
    _doseController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  void _modifyPrescription() {
    final updatedText = _doseController.text.trim();
    if (updatedText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Details cannot be empty!")),
      );
      return;
    }

    widget.prescription.extractedText = updatedText;
    widget.objectBox.prescriptionBox.put(widget.prescription);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Prescription updated successfully!")),
    );

    Navigator.of(context).pop(); // Return to the previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101631),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101631),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Medication Tracker",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Prescription Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _doseController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: "Prescription Text",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1A1E39),
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
                labelText: "Frequency",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1A1E39),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _modifyPrescription,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBBBFFE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Modify",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
