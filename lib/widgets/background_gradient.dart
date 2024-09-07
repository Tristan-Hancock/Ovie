import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  final Widget child;

  const BackgroundGradient({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF011E3D), // Very dark blue at the top
            Color(0xFF022C50), // Slightly lighter dark blue in the middle
            Color(0xFF033D63), // A more muted darker blue
            Color(0xFF044A7C), // Another dark blue for depth near the bottom
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.4, 0.7, 1.0], // Smooth transitions for dark theme
        ),
      ),
      child: child,
    );
  }
}
