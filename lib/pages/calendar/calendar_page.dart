import 'package:flutter/material.dart';
import 'package:ovie/services/objectbox.dart';
import 'calendar_dates.dart';

class CalendarPage extends StatelessWidget {
  final ObjectBox objectBox; // Pass ObjectBox instance to save data

  CalendarPage({Key? key, required this.objectBox}) : super(key: key);

  // Function to wipe all period tracking data from ObjectBox
  void _wipePeriodData(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Wipe Data'),
          content: Text('Are you sure you want to delete all period cycle data? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without doing anything
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Delete all period tracking data from ObjectBox
                objectBox.periodTrackingBox.removeAll();
                Navigator.of(context).pop(); // Close the dialog after deleting
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('All period cycle data wiped successfully.'),
                ));
              },
              child: Text('Wipe Data'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101631), // Dark background color
      appBar: AppBar(
        backgroundColor: Color(0xFF101631),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/icons/ovelia3.png', // Logo asset path
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Calendar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'wipe') {
                _wipePeriodData(context); // Call the function to wipe data
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'wipe',
                  child: Text('Wipe Period Cycle Data'),
                ),
              ];
            },
            icon: Icon(Icons.more_vert), // 3-dots menu icon
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CalendarDates(objectBox: objectBox), // Call the scrollable calendar here
      ),
    );
  }
}
