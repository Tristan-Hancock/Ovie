import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthUser; // Prefix for Firebase Auth's User
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ovie/services/models.dart' as ObjectBoxModel; // Prefix for ObjectBox's User
import 'package:ovie/objectbox.g.dart'; // Import the ObjectBox generated code
import 'package:ovie/services/objectbox.dart';

class DailyReport {
  final ObjectBox objectBox; // ObjectBox instance to fetch data

  DailyReport({required this.objectBox});

  // Function to check if a date has a daily log entry
  bool isDateLogged(DateTime date, List<ObjectBoxModel.DailyLog> savedDailyLogs) {
    String dateString = DateFormat('yyyy-MM-dd').format(date);
    for (var log in savedDailyLogs) {
      if (log.date == dateString) {
        return true;
      }
    }
    return false;
  }

  // Function to get log details for a selected date
  ObjectBoxModel.DailyLog? getLogForDate(DateTime date, List<ObjectBoxModel.DailyLog> savedDailyLogs) {
    String dateString = DateFormat('yyyy-MM-dd').format(date);
    for (var log in savedDailyLogs) {
      if (log.date == dateString) {
        return log;
      }
    }
    return null;
  }

  // Function to show a modal bottom sheet with log details for a specific date
void showLogDetails(BuildContext context, ObjectBoxModel.DailyLog log) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFBBBFFE), // Match the Figma background color
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Large image and log details
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date on top left
                  Text(
                    '${DateFormat('d MMMM').format(DateTime.parse(log.date))}', // Date formatting
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  
                  // Symptoms list under the date
                  Text('Menstruation: ${log.isMenstruation ? "Yes" : "No"}'),
                  Text('Cramps: ${log.isCramps ? "Yes" : "No"}'),
                  Text('Acne: ${log.isAcne ? "Yes" : "No"}'),
                  Text('Headaches: ${log.isHeadaches ? "Yes" : "No"}'),
                  
                  SizedBox(height: 20), // Space between text and image

                  // Large image section below the details
                  if (log.imagePath != null)
                    Container(
                      height: 250, // Larger height to emphasize the image
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(log.imagePath!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[300], // Placeholder color if no image
                      ),
                      child: Icon(Icons.image, size: 100, color: Colors.grey[700]), // Placeholder icon
                    ),
                ],
              ),
            ),

            SizedBox(width: 20), // Space between the two columns

            // Right Column: "I'm feeling" and "I'm thinking" sections stacked
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "I'm feeling" Section
                  Text(
                    "I'm feeling",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Text(
                        log.emotion,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20), // Space between sections

                  // "I'm thinking" Section
                  Text(
                    "I'm thinking",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Text(
                        log.imagePath != null ? "See Image" : "No data available",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}



  // Function to fetch all the daily logs from ObjectBox
  Future<List<ObjectBoxModel.DailyLog>> fetchDailyLogs(ObjectBoxModel.User user) async {
    return objectBox.dailyLogBox.query(DailyLog_.user.equals(user.id)).build().find();
  }

  // Fetch and return a list of daily logs for the logged-in user
  Future<List<ObjectBoxModel.DailyLog>> fetchLogsForCurrentUser() async {
    final firebaseUser = FirebaseAuthUser.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      print('No user logged in');
      return [];
    }

    final user = objectBox.userBox.query(User_.userId.equals(firebaseUser.uid)).build().findFirst();
    if (user == null) {
      print('User not found in local database');
      return [];
    }

    return fetchDailyLogs(user);
  }
}
