import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ovie/services/auth_service.dart'; // Import your AuthService

class CommunityMenu extends StatefulWidget {
  final AnimationController animationController;
  final bool isDrawerOpen;
  final String selectedCommunity;
  final Function(String) onCommunitySelected;
  final Function(String) onCommunitySelectedForOverlay;

  CommunityMenu({
    required this.animationController,
    required this.isDrawerOpen,
    required this.selectedCommunity,
    required this.onCommunitySelected,
    required this.onCommunitySelectedForOverlay,
  });

  @override
  _CommunityMenuState createState() => _CommunityMenuState();
}

class _CommunityMenuState extends State<CommunityMenu> {
  final AuthService _authService = AuthService();
  bool _isYourCommunities = true;

@override
Widget build(BuildContext context) {
  return AnimatedBuilder(
    animation: widget.animationController,
    builder: (context, child) {
      return Transform.translate(
        offset: Offset(-250 * (1 - widget.animationController.value), 0),
        child: Container( // Use Container instead of BackgroundGradient
          color: Color(0xFF101631), // Set the solid background color
          width: 250,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wrap the "Your Communities" and "All Communities" in a light blue background
                Container(
                  color: Color(0xFFBBBFFE), // Light blue background
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _isYourCommunities ? 'Your Communities' : 'All Communities',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis, // Prevents overflow by truncating text
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isYourCommunities ? Icons.group : Icons.public,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _isYourCommunities = !_isYourCommunities;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Create a Community Button Section with main background color
                Container(
                  color: Color(0xFF101631), // Use the main background color
                  child: ListTile(
                    leading: Icon(Icons.add, color: Color(0xFFF4608B)),
                    title: Text(
                      'Create a community',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      _showCreateCommunityDialog(context);
                    },
                  ),
                ),
                Divider(height: 1, color: Colors.grey[300]), // Light divider between sections
                // List of Communities Wrapped in main background color
                Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                    future: _isYourCommunities
                        ? _authService.getJoinedCommunities()
                        : FirebaseFirestore.instance.collection('communities').get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No communities found'));
                      }
                      return ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var community = snapshot.data!.docs[index];
                          return _buildCommunityItem(context, community);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  Widget _buildCommunityItem(BuildContext context, DocumentSnapshot community) {
    String communityName = community['name'];
    return FutureBuilder<bool>(
      future: _authService.isCommunityJoined(community.id),
      builder: (context, snapshot) {
        bool isJoined = snapshot.data ?? false;
        return Container(
          margin: EdgeInsets.only(bottom: 10.0), // Add spacing between items
          color: Color(0xFF101631), // Main background color for each community item
          child: ListTile(
            title: Text(
              communityName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                isJoined ? Icons.star : Icons.star_border,
                color: isJoined ? Color(0xFFF4608B) : Colors.white,
              ),
              onPressed: () async {
                if (isJoined) {
                  await _authService.leaveCommunity(community.id);
                } else {
                  await _authService.joinCommunity(community.id);
                }
                setState(() {}); // Refresh the community list after join/leave action
              },
            ),
            onTap: () {
              widget.onCommunitySelectedForOverlay(community.id);
            },
          ),
        );
      },
    );
  }

  void _showCreateCommunityDialog(BuildContext context) {
    TextEditingController _communityController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create a community'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _communityController,
                decoration: InputDecoration(
                  hintText: 'Community name',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () async {
                String communityName = _communityController.text.trim();
                String description = _descriptionController.text.trim();
                if (communityName.isNotEmpty && description.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('communities').add({
                    'name': communityName,
                    'description': description,
                    'createdAt': FieldValue.serverTimestamp(),
                    'creatorId': FirebaseAuth.instance.currentUser!.uid,
                    'followers': [],
                  });
                  Navigator.of(context).pop();
                  setState(() {}); // Refresh the community list after creation
                }
              },
              child: Text('Create', style: TextStyle(color: Color(0xFFF4608B))), // Pink create button
            ),
          ],
        );
      },
    );
  }
}
