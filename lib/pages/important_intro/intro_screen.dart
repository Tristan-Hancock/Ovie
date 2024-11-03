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
                    "Ovelia",
                    style: GoogleFonts.bonaNova(
                      fontSize: 65,
                      color: Colors.black,
                    ),
                  ),
                ),
                Spacer(), // Pushes content down
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text(
                      'Get started',
                      style: GoogleFonts.bonaNova(
                        fontSize: 26, // might need to change later
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 3, 1, 3), // Confirm from UI designer later
                      foregroundColor: Color(0xFFFEFEFA), // Softer white for text
                      padding: EdgeInsets.symmetric(vertical: 12),
                      minimumSize: Size(double.infinity, 60), // Set a fixed height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Less rounded corners
                      ),
                      elevation: 4, // Button shadow
                    ),
                  ),
                ),
                SizedBox(height: 40), // Adjust space at the bottom if necessary
              ],
            ),
          ),
        ),
      ),
    );
  }
}
