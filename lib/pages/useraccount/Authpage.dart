import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ovie/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ovie/pages/important_intro/intro_check.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isSignIn = true; // Toggle between sign-in and sign-up
@override
Widget build(BuildContext context) {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (snapshot.hasData) {
        // User is logged in, navigate to MainScreen
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          bool showIntro = await IntroCheck.isFirstTime();
          Navigator.pushReplacementNamed(context, showIntro ? '/intro' : '/home');
        });
        return Container(); // Placeholder while navigating
      } else {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ),
            if (!_isSignIn) // Show username field for sign-up
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_isSignIn) {
                  User? user = await _authService.signInWithEmail(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (user != null) {
                    bool showIntro = await IntroCheck.isFirstTime();
                    Navigator.pushReplacementNamed(context, showIntro ? '/intro' : '/home');
                  }
                } else {
                  User? user = await _authService.signUpWithEmail(
                    _emailController.text,
                    _passwordController.text,
                    _usernameController.text,
                  );
                  if (user != null) {
                    bool showIntro = await IntroCheck.isFirstTime();
                    Navigator.pushReplacementNamed(context, showIntro ? '/intro' : '/home');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDCAAC5),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSignIn = !_isSignIn;
                });
              },
              child: Text(_isSignIn ? 'Create an account' : 'Have an account? Sign in'),
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = await _authService.signInWithGoogle();
                if (user != null) {
                  bool showIntro = await IntroCheck.isFirstTime();
                  Navigator.pushReplacementNamed(context, showIntro ? '/intro' : '/home');
                }
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
    
});

}}