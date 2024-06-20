import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavigation({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Ensure the type is fixed
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.calendar),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.users),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.user),
          label: 'Account',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: widget.onItemTapped,
      backgroundColor: Color(0xFFF9EAEA), // Set the background color
    );
  }
}
