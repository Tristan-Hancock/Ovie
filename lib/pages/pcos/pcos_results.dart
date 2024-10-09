import 'package:flutter/material.dart';

class PcosResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101631), // Dark background color matching the theme
      appBar: AppBar(
        backgroundColor: Color(0xFF101631), // AppBar background color to match the theme
        elevation: 0, // Remove the shadow under the AppBar
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page (HomePage)
          },
        ),
        title: Text(
          'PCOS Risk Assessment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center elements horizontally
          children: [
            SizedBox(height: 30), // Space at the top
            // Circular widget to show percentage and risk level
            Container(
              width: 240, // Adjust width to match design
              height: 240, // Adjust height to match design
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFBBBFFE), Color(0xFF101631)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your PCOS risk is',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFFDE7E7), // Text color matching the design
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '75%', // Percentage value
                      style: TextStyle(
                        fontSize: 60, // Large font for percentage
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'High', // Risk level
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFFDE7E7), // Text color for the risk level
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40), // Space between the circle and the buttons
            // Buttons for different actions
            buildOutlinedButton(context, 'What does this mean?'),
            SizedBox(height: 16),
            buildOutlinedButton(context, 'Learn more about PCOS'),
            SizedBox(height: 16),
            buildOutlinedButton(context, 'Find a doctor near you'),
            Spacer(), // Push the disclaimer text to the bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'This screening test is merely a screening tool and not a diagnostic tool. '
                'Please consult a healthcare provider for a proper diagnosis.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white60,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20), // Space at the bottom
          ],
        ),
      ),
    );
  }

  // Function to build the outlined buttons
  Widget buildOutlinedButton(BuildContext context, String text) {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          // Define your button action here
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFFBBBFFE), width: 2), // Border color matching theme
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Rounded corners
          ),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust padding for size
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFBBBFFE), // Button text color matching the border
          ),
        ),
      ),
    );
  }
}
