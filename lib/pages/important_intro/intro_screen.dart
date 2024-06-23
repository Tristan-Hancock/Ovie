import 'package:flutter/material.dart';
import 'package:ovie/widgets/background_gradient.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                Center(
                  child: Text(
                    "ovie.",
                    style: GoogleFonts.bonaNova(
                      fontSize: 65,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/fatyellowoman.png', width: 90),
                          Image.asset('assets/images/file.png', width: 90),
                          Image.asset('assets/images/suitwoman.png', width: 90),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20.0),
  child: ElevatedButton(
    onPressed: () {
      Navigator.pushReplacementNamed(context, '/home');
    },
    child: Text(
      'Get started',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 246, 138, 206), // Adjusted to match the image change to FECCEA later
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12),
      minimumSize: Size(double.infinity, 78), // Set a fixed height
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Less rounded corners
      ),
      elevation: 0, // Remove shadow
    ),
  ),
),
SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}