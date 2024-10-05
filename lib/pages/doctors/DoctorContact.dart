import 'package:flutter/material.dart';

class DoctorContact extends StatelessWidget {
  final List<Map<String, String>> doctors = [
    {
      'name': 'Dr. Ophelia M.D.',
      'address': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'phone': '1000000000',
    },
    {
      'name': 'Dr. James Smith',
      'address': '123 Main St, New York City, NY',
      'phone': '1234567890',
    },
    {
      'name': 'Dr. Anna Johnson',
      'address': '456 Broadway, New York City, NY',
      'phone': '0987654321',
    },
    // Add more doctors as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF101631), // Dark background color
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctors Near Me',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'New York City',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () {
              // Add filter functionality here later
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 16),
            // Doctors list
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(doctors[index]['name']!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctors[index]['address']!),
                          SizedBox(height: 5),
                          Text('Phone no.: ${doctors[index]['phone']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
