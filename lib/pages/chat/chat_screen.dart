import 'package:flutter/material.dart';
import 'package:ovie/widgets/background_gradient.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 252, 208, 208),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Chat', style: TextStyle(color: Colors.black)),
          ),
          body: Center(child: Text('Chat Content')),
        ),
      ),
    );
  }
}
