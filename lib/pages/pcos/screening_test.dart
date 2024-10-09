import 'package:flutter/material.dart';
import 'pcos_results.dart'; // Import the PcosResultsPage here

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
            Navigator.pop(context); // Go back to the previous page (HomePage)
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
                fontFamily: 'Quicksand', // Font family from the settings
                fontWeight: FontWeight.w300, // SemiBold is equivalent to w600
                fontSize: 48, // Font size set to 48
                color: Color(0xFFFDE7E7), // Text color from the 'Fill' section in the image
                height: 1.2, // Adjust the line height if needed to match Figma's spacing
              ),
              textAlign: TextAlign.left, // Align text to the left as shown in the image
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
                  // Navigate to the PCOS Results Page when Start Screening is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PcosResultsPage(), // Navigate to PcosResultsPage
                    ),
                  );
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
                  // Define action for About the Test if needed
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
                  // Define action for Learn more about PCOS if needed
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
