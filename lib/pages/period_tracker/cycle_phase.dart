import 'dart:math';
import 'package:flutter/material.dart';

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
      ..color = Color(0xFFFF7BAA)
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
