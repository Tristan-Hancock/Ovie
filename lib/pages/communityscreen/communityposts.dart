import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovie/widgets/background_gradient.dart'; // Import the custom background gradient

class CommunityPostsOverlay extends StatelessWidget {
  final String communityId;
  final VoidCallback onClose;

  CommunityPostsOverlay({required this.communityId, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return BackgroundGradient(
      child: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onClose,
            ),
            title: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('communities').doc(communityId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }
                if (!snapshot.hasData) {
                  return Text('Community');
                }
                var communityData = snapshot.data!.data() as Map<String, dynamic>;
                return Text(communityData['name']);
              },
            ),
            backgroundColor: Color.fromARGB(255, 252, 208, 208),
          ),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('communities').doc(communityId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text('Community not found'));
                }
                var communityData = snapshot.data!.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        communityData['name'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        communityData['description'],
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('communities')
                              .doc(communityId)
                              .collection('posts')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Center(child: Text('No posts available.', style: TextStyle(color: Colors.black)));
                            }
                            return ListView(
                              children: snapshot.data!.docs.map((doc) {
                                var postData = doc.data() as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Color.fromARGB(255, 255, 255, 255)), // Add bottom border here
                                      ),
                                    ),
                                    child: ListTile(
                                      tileColor: Colors.transparent, // Make background transparent
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                      title: Text(
                                        postData['username'] ?? 'Unknown',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5),
                                          Text(
                                            postData['content'],
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      // Add upvote functionality here
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/upvote.png',
                                                      height: 20.0,
                                                      width: 20.0,
                                                    ),
                                                  ),
                                                  SizedBox(width: 3), // Adjust space here
                                                  Text(
                                                    postData['upvotes'].toString(),
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 15), // Adjust space between icon sets here
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      // Add comment functionality here
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/chaticon.png',
                                                      height: 20.0,
                                                      width: 20.0,
                                                    ),
                                                  ),
                                                  SizedBox(width: 3), // Adjust space here
                                                  Text(
                                                    postData['comments'].isNotEmpty ? '1' : '0',
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 15), // Adjust space between icon sets here
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      print('send messsage click');
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/sendtoDM.png',
                                                      height: 20.0,
                                                      width: 20.0,
                                                    ),
                                                  ),
                                                  SizedBox(width: 3), // Adjust space here
                                                  Text(
                                                    postData['saved'] ? '1' : '0',
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      isThreeLine: true,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
