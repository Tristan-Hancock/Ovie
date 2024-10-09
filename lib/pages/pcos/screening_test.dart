import 'package:flutter/material.dart';

class ScreeningTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101631), // Dark background color matching the theme
      appBar: AppBar(
        backgroundColor: Color(0xFF101631), // Same as the background to blend in
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding for consistent spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the left
          children: [
            SizedBox(height: 40), // Add spacing from the top
            Text(
              'The\nPCOS\nScreening\nTest',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20), // Space between the title and description
            Text(
              'Irregular periods, fertility struggles, or unexpected hair growth? '
              'It could be PCOS. Take our quick test to find out!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70, // Slightly lighter color for the description
              ),
            ),
            SizedBox(height: 40), // Space between the description and the buttons

            // Start Screening Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press for Start Screening
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBBBFFE), // Color matching the app theme
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust padding for size
                ),
                child: Text(
                  'Start Screening',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // White text color for contrast
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Space between the buttons

            // About the Test Button
            Center(
              child: OutlinedButton(
                onPressed: () {
                  // Handle button press for About the Test
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFFBBBFFE), width: 2), // Border color to match theme
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust padding for size
                ),
                child: Text(
                  'About the Test',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFBBBFFE), // Button text color matching the border
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Space between buttons

            // Learn More about PCOS Button
            Center(
              child: OutlinedButton(
                onPressed: () {
                  // Handle button press for Learn more about PCOS
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFFBBBFFE), width: 2), // Border color to match theme
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust padding for size
                ),
                child: Text(
                  'Learn more about PCOS',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFBBBFFE), // Button text color matching the border
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
