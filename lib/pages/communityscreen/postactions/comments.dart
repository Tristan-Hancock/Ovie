import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  final String postId;

  const CommentsPage({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController _commentController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = _fetchComments();
  }

  Future<List<Map<String, dynamic>>> _fetchComments() async {
    // Replace with your fetch logic. Here, returning a dummy list for demonstration.
    return [
      {
        'username': 'User1',
        'content': 'This is a comment',
        'timestamp': DateTime.now(),
      },
      {
        'username': 'User2',
        'content': 'This is another comment',
        'timestamp': DateTime.now(),
      },
    ];
  }

  Future<void> _addComment() async {
    // Replace with your add comment logic.
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _commentsFuture = _fetchComments(); // Refresh the comments
      });
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              AppBar(
                title: Text('Comments'),
                backgroundColor: Color.fromARGB(255, 252, 208, 208),
                automaticallyImplyLeading: false,
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _commentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No comments yet'));
                    }

                    var comments = snapshot.data!;

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        var comment = comments[index];
                        return ListTile(
                          title: Text(comment['username']),
                          subtitle: Text(comment['content']),
                          trailing: Text(comment['timestamp'].toString()),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _addComment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
