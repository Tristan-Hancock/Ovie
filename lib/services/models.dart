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

  DailyLog({
    this.id = 0,
    required this.date,
    required this.isMenstruation,
    required this.isCramps,
    required this.isAcne,
    required this.isHeadaches,
    required this.emotion,
    this.imagePath,
  });
}