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
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${log.date}', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Menstruation: ${log.isMenstruation ? "Yes" : "No"}'),
              Text('Cramps: ${log.isCramps ? "Yes" : "No"}'),
              Text('Acne: ${log.isAcne ? "Yes" : "No"}'),
              Text('Headaches: ${log.isHeadaches ? "Yes" : "No"}'),
              Text('Emotion: ${log.emotion}'),
              if (log.imagePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.file(
                    File(log.imagePath!), 
                    width: 100, 
                    height: 100,
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
