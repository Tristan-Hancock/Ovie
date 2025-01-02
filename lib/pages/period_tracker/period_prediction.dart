import 'package:ovie/services/models.dart';

class PeriodPrediction {
  final List<PeriodTracking> savedPeriods;

  PeriodPrediction({required this.savedPeriods});

  // Use a fixed cycle length of 28 days
  int getCycleLength() {
    return 28; // Fixed to 28 days
  }

  // Predict future periods based on a 28-day cycle
  List<DateTime> predictNextPeriods({int numberOfCycles = 1}) {
    final List<DateTime> predictedPeriods = [];
    
    if (savedPeriods.isNotEmpty) {
      final lastPeriod = savedPeriods.last;
      DateTime nextStart = lastPeriod.startDate.add(Duration(days: getCycleLength())); // Use startDate with 28-day cycle

      for (int i = 0; i < numberOfCycles; i++) {
        predictedPeriods.add(nextStart);
        nextStart = nextStart.add(Duration(days: getCycleLength())); // Predict with fixed 28-day cycle
      }
    }
    return predictedPeriods;
  }
}
