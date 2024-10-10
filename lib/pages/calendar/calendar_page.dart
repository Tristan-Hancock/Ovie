import 'package:flutter/material.dart';
import 'package:ovie/services/objectbox.dart';
import 'calendar_dates.dart';

class CalendarPage extends StatelessWidget {

  final ObjectBox objectBox; // Pass ObjectBox instance to save data

  CalendarPage({Key? key, required this.objectBox}) : super(key: key);

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CalendarDates(objectBox: objectBox), // Call the scrollable calendar here
      ),
    );
  }
}
