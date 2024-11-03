import 'package:objectbox/objectbox.dart';
import 'models.dart'; // Import the models (ensure Prescription model is in models.dart)
import 'package:ovie/objectbox.g.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider

class ObjectBox {
  late final Store store;

  // Boxes to store the data
  late final Box<User> userBox;
  late final Box<DailyLog> dailyLogBox;
  late final Box<PeriodTracking> periodTrackingBox;
  late final Box<Prescription> prescriptionBox; // Box for Prescription entity

  ObjectBox._create(this.store) {
    // Assign the boxes
    userBox = Box<User>(store);
    dailyLogBox = Box<DailyLog>(store);
    periodTrackingBox = Box<PeriodTracking>(store);
    prescriptionBox = Box<Prescription>(store); // Initialize Prescription box

    print("ObjectBox initialized with User, DailyLog, PeriodTracking, and Prescription boxes.");
  }

  /// Create an instance of ObjectBox to manage the database
  static Future<ObjectBox> create() async {
    // Get the app's document directory (writable)
    final appDir = await getApplicationDocumentsDirectory();

    // Ensure the directory is correct and writable
    final store = await openStore(directory: "${appDir.path}/objectbox");
    assert(store != null, 'ObjectBox store could not be opened'); // Add this assert

    print("ObjectBox store opened at ${appDir.path}/objectbox.");
    return ObjectBox._create(store);
  }

  /// Save a Prescription entity to ObjectBox
  void savePrescription(Prescription prescription) {
    prescriptionBox.put(prescription);
    print("Prescription saved: ${prescription.title} with scan date ${prescription.scanDate}");
  }

  /// Retrieve all saved prescriptions
  List<Prescription> getAllPrescriptions() {
    final prescriptions = prescriptionBox.getAll();
    print("Fetched ${prescriptions.length} prescriptions from ObjectBox.");
    return prescriptions;
  }
}
