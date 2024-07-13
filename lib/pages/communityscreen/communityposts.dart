import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovie/widgets/background_gradient.dart'; // Import the custom background gradient
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ovie/pages/communityscreen/create_posts.dart';

class CommunityPostsOverlay extends StatelessWidget {
  final String communityId;
  final VoidCallback onClose;

  CommunityPostsOverlay({required this.communityId, required this.onClose});

 


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: BackgroundGradient(
        child: Scaffold(
          backgroundColor: Colors.transparent, // Ensure the background is transparent
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onClose,
            ),
            title: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('communities')
                  .doc(communityId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }
                if (!snapshot.hasData) {
                  return Text('Community');
                }
                var communityData =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Text(communityData['name']);
              },
            ),
            backgroundColor: Color.fromARGB(255, 252, 208, 208),
          ),
          body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('communities')
                .doc(communityId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return Center(child: Text('Community not found'));
              }
              var communityData =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      communityData['name'],
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      communityData['description'],
                      style: TextStyle(fontSize: 16),
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No posts available.'));
                          }
                          return ListView(
                            children: snapshot.data!.docs.map((doc) {
                              var postData = doc.data() as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                                    ),
                                  ),
                                  child: ListTile(
                                    tileColor: Colors.transparent,
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
                                                SizedBox(width: 3),
                                                Text(
                                                  postData['upvotes'].toString(),
                                                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 15),
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
                                                SizedBox(width: 3),
                                                Text(
                                                  postData['comments'].isNotEmpty ? '1' : '0',
                                                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 15),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    print('send message click');
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/sendtoDM.png',
                                                    height: 20.0,
                                                    width: 20.0,
                                                  ),
                                                ),
                                                SizedBox(width: 3),
                                                Text(
                                                  postData['saved'] ? '1' : '0',
                                                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
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
          floatingActionButton: FloatingActionButton(
            onPressed: () =>  showAddPostDialog(context, communityId),
            child: Icon(Icons.add),
            backgroundColor: const Color.fromARGB(255, 248, 207, 221),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }
}
