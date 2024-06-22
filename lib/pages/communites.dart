import 'package:flutter/material.dart';
import 'package:ovie/widgets/background_gradient.dart';
class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
      backgroundColor: Color.fromARGB(255, 252, 208, 208), // Set the background color
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  // Handle hamburger menu action
                  print('hamburger clicked');
                },
              ),
              Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle unread tab action
                      print('unread tapped');
                    },
                    child: Text('Unread', style: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      // Handle saved tab action
                      print('Saved tapped');
                    },
                    child: Text('Saved', style: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.black),
                    onPressed: () {
                      // Handle send action
                      print('send message tapped');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        body: BackgroundGradient(
          child: TabBarView(
            children: [
              Center(child: Text('Unread Posts')),
              Center(child: Text('Saved Posts')),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Handle add post action
            print('tapped +');
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.pink, // You can set the color as per your theme
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
