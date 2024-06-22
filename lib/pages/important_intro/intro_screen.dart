import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:ovie/widgets/background_gradient.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "ovie.",
              body: "",
              image: Container(
                height: 300,
                child: Image.asset(
                  'assets/women.png',
                  fit: BoxFit.contain,
                ),
              ),
              footer: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text('Get started'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDCAAC5),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              decoration: const PageDecoration(
                titleTextStyle: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                bodyTextStyle: TextStyle(fontSize: 18),
                imagePadding: EdgeInsets.all(24),
                pageColor: Colors.transparent,
              ),
            ),
          ],
          onDone: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          showSkipButton: false,
          showNextButton: false,
          done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
          dotsDecorator: DotsDecorator(
            size: const Size(10.0, 10.0),
            color: Colors.black26,
            activeSize: const Size(22.0, 10.0),
            activeColor: Theme.of(context).colorScheme.secondary,
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}
