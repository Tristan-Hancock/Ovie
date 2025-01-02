import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  int id;
  String userId; // Firebase or Auth ID

  User({this.id = 0, required this.userId});
}

@Entity()
class DailyLog {
  int id;
  String date; // Store date as a string to simplify querying by day
  bool isMenstruation;
  bool isCramps;
  bool isAcne;
  bool isHeadaches;
  String emotion; // Smiling, Neutral, Frowning, Pouting
  String? imagePath; // Local path of the saved image
  final user = ToOne<User>(); // Link to User
  String? textlog;

  DailyLog({
    this.id = 0,
    required this.date,
    required this.isMenstruation,
    required this.isCramps,
    required this.isAcne,
    required this.isHeadaches,
    required this.emotion,
    this.textlog,
    this.imagePath,
  });
}

@Entity()
class PeriodTracking {
  int id;
  DateTime startDate; // The start date of the period
  DateTime endDate; // The end date of the period
  final user = ToOne<User>(); // Link to User

  PeriodTracking({
    this.id = 0,
    required this.startDate,
    required this.endDate,
  });
}


@Entity()
class Prescription {
  int id = 0; // ObjectBox will auto-increment this field
  String title;
  String extractedText;
  DateTime scanDate;
  String? frequency; // Frequency of medication (e.g., "2 times a day")
  DateTime? startDate; // Start date of the medication schedule
  List<String>? times; // List of times for taking medication (e.g., ["8:00 AM", "8:00 PM"])

  Prescription({
    this.id = 0,
    required this.title,
    required this.extractedText,
    required this.scanDate,
    this.frequency, // Optional frequency
    this.startDate, // Optional start date
    this.times, // Optional list of times
  });
}
