import 'package:flutter/material.dart';
import 'package:ovie/services/models.dart';
import 'package:ovie/services/objectbox.dart';

class MedicationSection extends StatefulWidget {
  final ObjectBox objectBox;

  const MedicationSection({Key? key, required this.objectBox}) : super(key: key);

  @override
  _MedicationSectionState createState() => _MedicationSectionState();
}

class _MedicationSectionState extends State<MedicationSection> {
  List<Prescription> _prescriptions = [];

  @override
  void initState() {
    super.initState();
    _loadPrescriptions();
  }

  Future<void> _loadPrescriptions() async {
    setState(() {
      _prescriptions = widget.objectBox.getAllPrescriptions();
    });
  }

  void _deletePrescription(Prescription prescription) {
    widget.objectBox.prescriptionBox.remove(prescription.id);
    _loadPrescriptions(); // Refresh the list
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prescription deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_prescriptions.isEmpty) {
      return const Center(
        child: Text(
          'No medications added yet.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _prescriptions.length,
        itemBuilder: (context, index) {
          final prescription = _prescriptions[index];
          return Dismissible(
            key: ValueKey(prescription.id),
            direction: DismissDirection.up,
            onDismissed: (direction) {
              _deletePrescription(prescription); // Delete on swipe
            },
            background: Container(
              alignment: Alignment.center,
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              color: const Color(0xFF1A1E39),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prescription.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prescription.frequency ?? "No frequency set",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
