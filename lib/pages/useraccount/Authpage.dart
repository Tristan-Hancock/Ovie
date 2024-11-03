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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101631), // Main background color
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App title
                Text(
                  'Ovelia',
                  style: GoogleFonts.quicksand(
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.25,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),

                // Form fields
                if (!_isSignIn) ...[
                  // Name field for sign-up
                  _buildTextField(controller: _nameController, labelText: 'Name'),
                  SizedBox(height: 10),
                  _buildTextField(controller: _emailController, labelText: 'Email'),
                  SizedBox(height: 10),
                  _buildTextField(controller: _usernameController, labelText: 'Username'),
                  SizedBox(height: 10),
                ],
                if (_isSignIn) _buildTextField(controller: _emailController, labelText: 'Username'),
                SizedBox(height: 10),
                _buildTextField(controller: _passwordController, labelText: 'Password', obscureText: true),
                SizedBox(height: 20),

                // Action button
                ElevatedButton(
                  onPressed: _isSignIn ? _signIn : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFBBBFFE),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(_isSignIn ? 'Login' : 'Sign Up'),
                ),
                SizedBox(height: 10),

                // Toggle Sign-in/Sign-up
                TextButton(
                  onPressed: () => setState(() => _isSignIn = !_isSignIn),
                  child: Text(
                    _isSignIn ? 'Don\'t have an account? Sign up' : 'Have an account? Sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                // Forgot Password link for Sign-In only
                if (_isSignIn)
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                // App logo at the bottom
                SizedBox(height: 50),
                Image.asset(
                  'assets/icons/auth.png',
                  width: 75,
                  height: 75,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Color(0xFF1A1E39),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    User? user = await _authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (user != null) {
      bool showIntro = await IntroCheck.isFirstTime();
      Navigator.pushReplacementNamed(context, showIntro ? '/intro' : '/home');
    }
  }

  Future<void> _signUp() async {
    User? user = await _authService.signUpWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _usernameController.text.trim(),
    );
    if (user != null) {
      bool showIntro = await IntroCheck.isFirstTime();
      Navigator.pushReplacementNamed(context, showIntro ? '/intro' : '/home');
    }
  }
}
