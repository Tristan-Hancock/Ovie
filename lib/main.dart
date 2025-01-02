import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ovie/pages/chat/chat_screen.dart';
import 'package:ovie/pages/doctors/DoctorContact.dart';
import 'package:ovie/pages/prescription/prescription_ui.dart';
import 'widgets/bottom_navigation.dart';
import 'pages/pcos/home_page.dart';
import 'pages/period_tracker/calendar_page.dart';
import 'pages/communityscreen/communityfeed.dart';
import 'pages/useraccount/Authpage.dart';
import 'pages/useraccount/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/objectbox.dart';
import 'package:ovie/objectbox.g.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize ObjectBox and log for debugging
  final objectBox = await ObjectBox.create();
  log('ObjectBox initialized successfully');

  final currentUser = FirebaseAuth.instance.currentUser;
  log('Current User: ${currentUser != null ? "Logged In" : "Not Logged In"}');

  runApp(MyApp(
    isLoggedIn: currentUser != null,
    objectBox: objectBox,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final ObjectBox objectBox;

  MyApp({
    required this.isLoggedIn,
    required this.objectBox,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ovelia',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF101631),
        textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme.copyWith(
            displayLarge: TextStyle(fontSize: 50, fontWeight: FontWeight.w600, color: Colors.white),
            bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
            bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ),
      ),
      initialRoute: _initialRoute(),
      routes: {
        '/': (context) => AuthPage(),
        '/home': (context) => MainScreen(objectBox: objectBox),
        '/calendar': (context) => CalendarPage(objectBox: objectBox),
        '/community': (context) => CommunityPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }

  String _initialRoute() {
    if (isLoggedIn) {
      return '/home'; // Always go to the home screen if logged in
    } else {
      return '/'; // Show the AuthPage if not logged in
    }
  }
}

class MainScreen extends StatefulWidget {
  final ObjectBox objectBox;

  MainScreen({required this.objectBox});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens for the navigation bar
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = [
      HomePage(objectBox: widget.objectBox),
      CalendarPage(objectBox: widget.objectBox),
      CommunityPage(),
      PrescriptionReader(objectBox: widget.objectBox),
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
