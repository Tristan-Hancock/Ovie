import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/background_gradient.dart';
import 'pages/home_page.dart';
import 'pages/calendar_page.dart';
import 'pages/communites.dart';
import 'pages/important_intro/intro_check.dart';
import 'pages/important_intro/intro_screen.dart';
import 'pages/useraccount/Authpage.dart';
import 'pages/useraccount/profile.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool showIntro = await IntroCheck.isFirstTime(); // Check if it's the first time
  await Firebase.initializeApp();
  runApp(MyApp(showIntro: showIntro));
}

class MyApp extends StatelessWidget {
  final bool showIntro;

  MyApp({required this.showIntro});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ovie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
 initialRoute: '/',
      routes: {
        '/': (context) => AuthPage(), // Ensure the root route is defined
  //need to fix this routing to stop showing the intro
        '/intro': (context) => IntroScreen(),
        '/home': (context) => MainScreen(),
        '/calendar': (context) => CalendarPage(),
        '/community': (context) => CommunityPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    HomePage(),
    CalendarPage(),
    CommunityPage(),
    ProfilePage(),
  ];

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
