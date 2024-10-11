import 'package:ovie/services/models.dart';

class PeriodPrediction {
  final List<PeriodTracking> savedPeriods;

  PeriodPrediction({required this.savedPeriods});

  // Function to calculate the average cycle length in days (start-to-start)
  int getAverageCycleLength() {
    if (savedPeriods.length < 2) {
      return 28; // Default to 28 days if there's not enough data
    }

    int totalDays = 0;
    for (int i = 1; i < savedPeriods.length; i++) {
      final prevPeriod = savedPeriods[i - 1];
      final currentPeriod = savedPeriods[i];
      totalDays += currentPeriod.startDate.difference(prevPeriod.startDate).inDays; // Difference between start dates
    }

    return (totalDays / (savedPeriods.length - 1)).round(); // Average cycle length
  }

  // Predict future periods based on average cycle length
  List<DateTime> predictNextPeriods({int numberOfCycles = 1}) {
    final List<DateTime> predictedPeriods = [];
    
    if (savedPeriods.isNotEmpty) {
      final lastPeriod = savedPeriods.last;
      DateTime nextStart = lastPeriod.startDate.add(Duration(days: getAverageCycleLength())); // Use startDate

      for (int i = 0; i < numberOfCycles; i++) {
        predictedPeriods.add(nextStart);
        nextStart = nextStart.add(Duration(days: getAverageCycleLength())); // Predict based on average cycle length
      }
    }
    return predictedPeriods;
  }
}
