import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ovie/services/objectbox.dart';
import 'package:ovie/services/models.dart';
import 'package:ovie/pages/period_tracker/period_prediction.dart';

class TrackerWidget extends StatefulWidget {
  final ObjectBox objectBox;

  TrackerWidget({required this.objectBox});

  @override
  _TrackerWidgetState createState() => _TrackerWidgetState();
}

class _TrackerWidgetState extends State<TrackerWidget> {
  late List<PeriodTracking> savedPeriods;
  late String nextPeriodDate = "Loading...";
  late String currentPhase = "Loading...";
  late int daysSinceLastPeriod = 0;

  @override
  void initState() {
    super.initState();
    _fetchCycleData();
  }

  Future<void> _fetchCycleData() async {
    // Fetch user's periods from ObjectBox
    savedPeriods = widget.objectBox.periodTrackingBox.getAll();

    if (savedPeriods.isNotEmpty) {
      savedPeriods.sort((a, b) => b.startDate.compareTo(a.startDate)); // Sort by date (descending)
      final lastPeriod = savedPeriods.first;

      // Calculate days since last period start
      daysSinceLastPeriod =
          DateTime.now().difference(lastPeriod.startDate).inDays;

      // Predict next period date
      final periodPrediction =
          PeriodPrediction(savedPeriods: savedPeriods); // Use prediction class
      final predictedPeriods = periodPrediction.predictNextPeriods();
      nextPeriodDate = predictedPeriods.isNotEmpty
          ? DateFormat('d MMMM').format(predictedPeriods.first)
          : "No data available";

      // Determine current phase
      int cycleLength = periodPrediction.getCycleLength();
      currentPhase =
          _determineCyclePhase(daysSinceLastPeriod, cycleLength, 5); // Period duration = 5 days
    } else {
      // No saved periods
      nextPeriodDate = "No data available";
      currentPhase = "No data available";
      daysSinceLastPeriod = 0;
    }

    setState(() {});
  }

  String _determineCyclePhase(
      int daysSinceLastPeriod, int cycleLength, int periodDuration) {
    if (daysSinceLastPeriod <= periodDuration) {
      return "Menstrual Phase";
    } else if (daysSinceLastPeriod <= (cycleLength / 2).floor()) {
      return "Follicular Phase";
    } else if (daysSinceLastPeriod == (cycleLength / 2).floor() + 1) {
      return "Ovulation Phase";
    } else {
      return "Luteal Phase";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2749),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Information
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your last period was $daysSinceLastPeriod days ago",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Do you have any symptoms today?",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7BAA),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text("Yes"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text("No"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Based on your last cycle, your next period is expected on $nextPeriodDate",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Cycle Phase
              Expanded(
                flex: 1,
                child: Center(
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: CustomPaint(
                      painter: CyclePhasePainter(
                        daysSinceLastPeriod,
                        28, // Default cycle length
                      ),
                      child: Center(
                        child: Text(
                          currentPhase,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CyclePhasePainter extends CustomPainter {
  final int cycleDay;
  final int cycleLength;

  CyclePhasePainter(this.cycleDay, this.cycleLength);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final progressPaint = Paint()
      ..color = const Color(0xFFFF7BAA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw base circle
    canvas.drawCircle(center, radius, paint);

    // Draw progress arc
    double sweepAngle = (cycleDay / cycleLength) * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from the top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
