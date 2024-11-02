import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ovie/pages/chat/chat_screen.dart';
import 'package:ovie/pages/doctors/DoctorContact.dart';
import 'package:ovie/pages/prescription/prescription_ui.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/background_gradient.dart';
import 'pages/pcos/home_page.dart';
import 'pages/calendar/calendar_page.dart';
import 'pages/communityscreen/communityfeed.dart';
import 'pages/important_intro/intro_check.dart';
import 'pages/important_intro/intro_screen.dart';
import 'pages/useraccount/Authpage.dart';
import 'pages/useraccount/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'widgets/top_bar.dart'; 
import 'services/objectbox.dart'; 
import 'package:ovie/objectbox.g.dart';
 //Update UI and flow pending for into


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  bool showIntro = await IntroCheck.isFirstTime();
  
  final objectBox = await ObjectBox.create(); // Initialize ObjectBox

  User? currentUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp(
    showIntro: showIntro, 
    isLoggedIn: currentUser != null,
    objectBox: objectBox, 
  ));
}

class MyApp extends StatelessWidget {
  final bool showIntro;
  final bool isLoggedIn;
  final ObjectBox objectBox; 

  MyApp({required this.showIntro, required this.isLoggedIn, required this.objectBox});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ovelia', 
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _initialRoute(),
      routes: {
        '/': (context) => AuthPage(),
        '/intro': (context) => IntroScreen(),
        '/home': (context) => MainScreen(objectBox: objectBox), 
        '/calendar': (context) => CalendarPage(objectBox: objectBox,),
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
      CalendarPage(objectBox: widget.objectBox,),
      CommunityPage(),
      // DoctorContact(), //replacing with prescription scanner for now
      PrescriptionReader(),
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
      body: BackgroundGradient(
        child: _widgetOptions.elementAt(_selectedIndex), 
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped, 
      ),
    );
  }
}
