import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ovie/pages/chat/chat_screen.dart';
import 'package:ovie/pages/doctors/DoctorContact.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/background_gradient.dart';
import 'pages/pcos/home_page.dart';
import 'pages/calendar_page.dart';
import 'pages/communityscreen/communityfeed.dart';
import 'pages/important_intro/intro_check.dart';
import 'pages/important_intro/intro_screen.dart';
import 'pages/useraccount/Authpage.dart';
import 'pages/useraccount/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'widgets/top_bar.dart'; // Import the TopBar

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool showIntro = await IntroCheck.isFirstTime(); // Check if it's the first time
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  User? currentUser = FirebaseAuth.instance.currentUser;
runApp(MyApp(showIntro: showIntro, isLoggedIn: currentUser !=null));
}

class MyApp extends StatelessWidget {
  final bool showIntro;
  final bool isLoggedIn;

  MyApp({required this.showIntro, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ovelia', // Update this to your desired app title
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _initialRoute(),
      routes: {
        '/': (context) => AuthPage(),
        '/intro': (context) => IntroScreen(),
        '/home': (context) => MainScreen(),
        '/calendar': (context) => CalendarPage(),
        '/community': (context) => CommunityPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }

  String _initialRoute() {
    if (isLoggedIn) {
      return showIntro ? '/intro' : '/home';
    } else {
      return '/';
    }
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens for the navigation bar
  final List<Widget> _widgetOptions = [
    HomePage(),
    CalendarPage(),
    CommunityPage(),
    DoctorContact(),
    ProfilePage(),  // Ensure ProfilePage is in this list
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // This will handle valid index from navigation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: _widgetOptions.elementAt(_selectedIndex), // Select screen based on index
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped, // Update the index on tab change
      ),
    );
  }
}