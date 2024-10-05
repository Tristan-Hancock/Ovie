import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavigation({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xFF101631), // Background color for the bottom navigation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('assets/icons/home.png', 0), // Home Icon
          _buildNavItem('assets/icons/calendar_month.png', 1), // Calendar Icon
          _buildNavItem('assets/icons/action_key.png', 2), // Search/Community Icon
           _buildNavItem('assets/icons/doctor.png', 3), // Chat Icon
          _buildNavItem('assets/icons/account.png', 4), // Account Icon
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            color: isSelected ? Color(0xFFFF599A) : Color(0xFFD9D9D9), // Switch between pink and grey based on selection
            height: 34, // Adjust icon size as per design
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
