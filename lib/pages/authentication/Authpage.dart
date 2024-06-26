import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ovie/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFFDCAAC5),
              Color(0xFFE5A2BD),
              Color(0xFFFCD9DA),
            ],
            stops: [0.26, 0.52, 1],
            center: Alignment.center,
            radius: 0.85,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ovie.',
              style: GoogleFonts.bonaNova(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                // User? user = await _authService.signInWithGoogle();
                // if (user != null) {
                //   Navigator.pushReplacementNamed(context, '/home');
                // }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDCAAC5),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
