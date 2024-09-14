import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovie/widgets/background_gradient.dart';
import 'package:ovie/pages/communityscreen/create_posts.dart';
import 'community_comments.dart';

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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 24), // Reduced icon size
              onPressed: onClose,
            ),
            title: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('communities')
                  .doc(communityId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    'Loading...',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Increased font size
                  );
                }
                if (!snapshot.hasData) {
                  return Text(
                    'Community',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Increased font size
                  );
                }
                var communityData = snapshot.data!.data() as Map<String, dynamic>;
                return Text(
                  communityData['name'],
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), // Increased font size
                );
              },
            ),
            backgroundColor: Color(0xFF010101),
            elevation: 0, // Removed shadow for a flat design
            centerTitle: true, // Centered the title
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
                return Center(
                  child: Text(
                    'Community not found',
                    style: TextStyle(color: Colors.white, fontSize: 18), // Increased font size
                  ),
                );
              }
              var communityData = snapshot.data!.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Standardized padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      communityData['name'],
                      style: TextStyle(
                        fontSize: 28, // Increased font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Changed to white for better contrast
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      communityData['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70, // Slightly lighter for contrast
                        height: 1.5, // Increased line height for readability
                      ),
                    ),
                    SizedBox(height: 16),
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
                            return Center(
                              child: Text(
                                'No posts available.',
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: snapshot.data!.docs.length,
                            separatorBuilder: (context, index) => SizedBox(height: 12), // Standard spacing between posts
                            itemBuilder: (context, index) {
                              var doc = snapshot.data!.docs[index];
                              var postData = doc.data() as Map<String, dynamic>;
                              return Container(
                                padding: EdgeInsets.all(16), // Standardized padding inside the post
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1), // Transparent white background
                                  borderRadius: BorderRadius.circular(12), // Consistent border radius
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ], // Subtle shadow for depth
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.pinkAccent,
                                          child: Text(
                                            postData['username'] != null && postData['username'].isNotEmpty
                                                ? postData['username'][0].toUpperCase()
                                                : 'U',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                postData['username'] ?? 'Unknown',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                _formatTimestamp(postData['timestamp']),
                                                style: TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      postData['content'] ?? '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _buildIconText(
                                          icon: Icons.thumb_up_alt_rounded,
                                          text: postData['upvotes']?.toString() ?? '0',
                                          color: Color(0xFFADA8BE),
                                          onTap: () {
                                            // Implement upvote functionality
                                          },
                                        ),
                                        SizedBox(width: 24),
                                        _buildIconText(
                                          icon: Icons.comment_rounded,
                                          text: (postData['comments'] != null && postData['comments'].isNotEmpty)
                                              ? postData['comments'].length.toString()
                                              : '0',
                                          color: Color(0xFFADA8BE),
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              builder: (context) => Padding(
                                                padding: const EdgeInsets.only(top: 50.0),
                                                child: CommunityCommentsPage(
                                                  communityId: communityId,
                                                  postId: doc.id,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(width: 24),
                                        _buildIconText(
                                          icon: Icons.bookmark_border_rounded,
                                          text: '',
                                          color: Colors.pinkAccent,
                                          onTap: () {
                                            // Implement save functionality
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
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
            onPressed: () => showAddPostDialog(context, communityId),
            child: Icon(Icons.add, size: 28), // Slightly increased icon size
            backgroundColor: const Color(0xFFB12D58),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Reduced roundness
            ),
            elevation: 6, // Subtle shadow
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }

  Widget _buildIconText({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20), // Standardized icon size
          if (text.isNotEmpty) ...[
            SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
