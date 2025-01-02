import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthUser; // Prefix for Firebase Auth's User
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ovie/services/models.dart' as ObjectBoxModel; // Prefix for ObjectBox's User
import 'package:ovie/objectbox.g.dart'; // Import the ObjectBox generated code
import 'package:ovie/services/objectbox.dart';
import '../../widgets/PeriodCycle/cycle_phase.dart';
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
void showLogDetails(
  BuildContext context,
  ObjectBoxModel.DailyLog log,
  DateTime lastPeriodStartDate,
  int cycleLength,
  int periodDuration,
) {
  // Calculate Cycle Day and Phase
  int daysSinceLastPeriod = DateTime.parse(log.date).difference(lastPeriodStartDate).inDays;
  int cycleDay = (daysSinceLastPeriod % cycleLength) + 1;
  String phase = determineCyclePhase(cycleDay, periodDuration);

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 164, 169, 249),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Symptoms and Image
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and Symptoms Section
                  Text(
                    'Today ${DateFormat('d MMMM').format(DateTime.parse(log.date))}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (log.isMenstruation) const Text('Menstruation', style: TextStyle(color: Colors.black)),
                  if (log.isCramps) const Text('Cramps', style: TextStyle(color: Colors.black)),
                  if (log.isAcne) const Text('Acne', style: TextStyle(color: Colors.black)),
                  if (log.isHeadaches) const Text('Headaches', style: TextStyle(color: Colors.black)),
                  if (!log.isMenstruation &&
                      !log.isCramps &&
                      !log.isAcne &&
                      !log.isHeadaches)
                    const Text('No symptoms logged', style: TextStyle(color: Colors.black)),
                  const SizedBox(height: 16),

                  // Image Section
                  if (log.imagePath != null)
                    Container(
                      height: 250,
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
                        color: Colors.grey[300],
                      ),
                      child:  Icon(Icons.image, size: 100, color: Colors.grey[700]),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Right Column: Menstrual Phase and Emotions
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menstrual Phase Progress Circle
                  Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CustomPaint(
                        painter: CyclePhasePainter(cycleDay, cycleLength),
                        child: Center(
                          child: Text(
                            phase,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // "I'm Feeling" Section
                  const Text(
                    "I'm feeling",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
  // Display emotion image (if available) based on the emotion
  if (log.emotion == 'Happy')
    Image.asset(
      'assets/icons/smiling.png',
      height: 24,
      width: 24,
    ),
  if (log.emotion == 'Neutral')
    Image.asset(
      'assets/icons/neutral.png',
      height: 24,
      width: 24,
    ),
  if (log.emotion == 'Sad')
    Image.asset(
      'assets/icons/frowning.png',
      height: 24,
      width: 24,
    ),
  if (log.emotion == 'Angry')
    Image.asset(
      'assets/icons/pouting.png',
      height: 24,
      width: 24,
    ),
  const SizedBox(width: 8),
  
],

                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // "I'm Thinking" Section
                  const Text(
                    "I'm thinking",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Text(
                        log.textlog ?? "No data available",
                        style: const TextStyle(fontSize: 16, color: Colors.black),
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




String _formatSymptoms(ObjectBoxModel.DailyLog log) {
  List<String> symptoms = [];
  if (log.isMenstruation) symptoms.add("Menstruation");
  if (log.isCramps) symptoms.add("Cramps");
  if (log.isAcne) symptoms.add("Acne");
  if (log.isHeadaches) symptoms.add("Headaches");

  return symptoms.isNotEmpty ? symptoms.join(", ") : "No symptoms logged";
}



String determineCyclePhase(int cycleDay, int periodDuration) {
  if (cycleDay <= periodDuration) {
    return "Menstrual Phase";
  } else if (cycleDay <= 14) {
    return "Follicular Phase";
  } else if (cycleDay == 14) {
    return "Ovulatory Phase";
  } else {
    return "Luteal Phase";
  }
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
