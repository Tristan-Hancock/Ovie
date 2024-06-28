import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ovie/widgets/background_gradient.dart';

class CommunityMenu extends StatelessWidget {
  final AnimationController animationController;
  final bool isDrawerOpen;
  final String selectedCommunity;
  final Function(String) onCommunitySelected;

  CommunityMenu({
    required this.animationController,
    required this.isDrawerOpen,
    required this.selectedCommunity,
    required this.onCommunitySelected,
  });
void _saveCommunity(String communityName) async {
  await FirebaseFirestore.instance.collection('communities').add({
    'name': communityName,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(-250 * (1 - animationController.value), 0),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          DropdownButton<String>(
                            value: selectedCommunity,
                            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            dropdownColor: Color.fromARGB(255, 252, 208, 208),
                            underline: Container(
                              height: 2,
                              color: Colors.transparent,
                            ),
                            onChanged: (String? newValue) {
                              onCommunitySelected(newValue!);
                            },
                            items: <String>['Your Communities', 'All Communities']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(16.0),
                        children: selectedCommunity == 'Your Communities'
                            ? [_buildCommunityItem('Safe sex')]
                            : [
                                _buildCommunityItem('Menstrual Cycle'),
                                _buildCommunityItem('Safe sex'),
                                _buildCommunityItem('Birth Control'),
                                _buildCommunityItem('Cramps'),
                                _buildCommunityItem('Puberty'),
                              ],
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

  Widget _buildCommunityItem(String communityName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        communityName,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }
}
