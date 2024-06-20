import 'package:flutter/material.dart';
import 'background_gradient.dart';

class CommonLayout extends StatelessWidget {
  final Widget child;
  final String title;

  const CommonLayout({Key? key, required this.child, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BackgroundGradient(
        child: child,
      ),
    );
  }
}
