import 'package:flutter/material.dart';
import 'package:ovie/widgets/background_gradient.dart';
import 'package:ovie/pages/chat/chat_screen.dart';
class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isDrawerOpen = false;
  String _selectedCommunity = 'My Communities';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            _buildMainContent(),
            _buildDrawer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(250 * _animationController.value, 0),
          child: BackgroundGradient(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 252, 208, 208),
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.black),
                      onPressed: _toggleDrawer,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => print('unread tapped'),
                          child: Text('Unread', style: TextStyle(color: Colors.black)),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => print('Saved tapped'),
                          child: Text('Saved', style: TextStyle(color: Colors.black)),
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChatScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: Center(child: Text('Main Content')),
              floatingActionButton: FloatingActionButton(
                onPressed: () => print('tapped +'),
                child: Icon(Icons.add),
                backgroundColor: const Color.fromARGB(255, 248, 207, 221),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(-250 * (1 - _animationController.value), 0),
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
        value: _selectedCommunity,
        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        dropdownColor: Color.fromARGB(255, 252, 208, 208),
        underline: Container(
          height: 2,
          color: Colors.transparent,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _selectedCommunity = newValue!;
          });
        },
        items: <String>['My Communities', 'All Communities']
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
                        children: _selectedCommunity == 'My Communities'
                            ? [
                                _buildCommunityItem('Safe sex'),
                              ]
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
