import 'package:objectbox/objectbox.dart';
import 'models.dart'; // Import the models
import 'package:ovie/objectbox.g.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider

class ObjectBox {
  late final Store store;

  // Boxes to store the data
  late final Box<User> userBox;
  late final Box<DailyLog> dailyLogBox;
  late final Box<PeriodTracking> periodTrackingBox;

  ObjectBox._create(this.store) {
    // Assign the boxes
    userBox = Box<User>(store);
    dailyLogBox = Box<DailyLog>(store);
    periodTrackingBox = Box<PeriodTracking>(store); // Initialize PeriodTracking Box

  }

  /// Create an instance of ObjectBox to manage the database
  static Future<ObjectBox> create() async {
    // Get the app's document directory (writable)
    final appDir = await getApplicationDocumentsDirectory();

    // Ensure the directory is correct and writable
    final store = await openStore(directory: "${appDir.path}/objectbox");

    return ObjectBox._create(store);
  }
}
