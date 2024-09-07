import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TopBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'BonaNova', // Set the font to Bona Nova
          color: Color(0xFFF46AA0), // Set the text color to pink from the palette
          fontSize: 28, // Increase the font size for better visibility
          fontWeight: FontWeight.bold, // Keep the text bold for emphasis
          shadows: [
            Shadow(
              offset: Offset(0, 1),
              blurRadius: 2.0,
              color: Color.fromARGB(150, 0, 0, 0), // Subtle shadow to make text pop
            ),
          ],
        ),
      ),
      centerTitle: true, // Center the title
      backgroundColor: Color(0xFF011E3D), // Dark blue background color
      elevation: 0, // Remove the shadow
      automaticallyImplyLeading: false, // Removes the back button
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
