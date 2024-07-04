import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ovie/widgets/background_gradient.dart';
import 'package:ovie/services/auth_service.dart'; // Import your AuthService
import 'package:ovie/pages/communityscreen/communityposts.dart';
import 'package:ovie/pages/communityscreen/communityposts.dart';
class CommunityMenu extends StatefulWidget {
  final AnimationController animationController;
  final bool isDrawerOpen;
  final String selectedCommunity;
  final Function(String) onCommunitySelected;
  final Function(String) onCommunitySelectedForOverlay; // Add this line

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
          child: BackgroundGradient(
            child: Container(
              width: 250,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isYourCommunities ? 'Your Communities' : 'All Communities',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isYourCommunities ? Icons.group : Icons.public,
                              color: Colors.white,
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
                    ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: Text(
                        'Create a community',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _showCreateCommunityDialog(context);
                      },
                    ),
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
      return ListTile(
        title: Text(
          communityName,
          style: TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
          icon: Icon(
            isJoined ? Icons.star : Icons.star_border,
            color: Colors.white,
          ),
          onPressed: () async {
            if (isJoined) {
              await _authService.leaveCommunity(community.id);
            } else {
              await _authService.joinCommunity(community.id);
            }
            (context as Element).markNeedsBuild(); // Refresh UI
          },
        ),
        onTap: () {
          widget.onCommunitySelectedForOverlay(community.id); // Use this line
        },
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
                decoration: InputDecoration(hintText: 'Community name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(hintText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
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
                  setState(() {}); // Refresh the community list
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
