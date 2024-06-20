import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovie/services/post_service.dart';
class CommunityPage extends StatelessWidget {
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Community'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Unread'),
              Tab(text: 'Saved'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UnreadPostsTab(postService: _postService),
            SavedPostsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePostPage(postService: _postService)),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class UnreadPostsTab extends StatelessWidget {
  final PostService postService;

  UnreadPostsTab({required this.postService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: postService.getPosts(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return Center(child: Text('No posts yet'));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return PostItem(
              username: doc['username'],
              timeAgo: doc['timeAgo'],
              content: doc['content'],
              likes: doc['likes'],
              comments: doc['comments'],
              shares: doc['shares'],
            );
          }).toList(),
        );
      },
    );
  }
}

class SavedPostsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Saved Posts'));
  }
}

class PostItem extends StatelessWidget {
  final String username;
  final String timeAgo;
  final String content;
  final int likes;
  final int comments;
  final int shares;

  PostItem({
    required this.username,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(timeAgo, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Text(content),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.comment),
                    SizedBox(width: 5),
                    Text('$comments'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.thumb_up),
                    SizedBox(width: 5),
                    Text('$likes'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 5),
                    Text('$shares'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePostPage extends StatelessWidget {
  final TextEditingController _contentController = TextEditingController();
  final PostService postService;

  CreatePostPage({required this.postService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'What\'s on your mind?'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await postService.createPost('userId', _contentController.text); // Replace 'userId' with actual user ID
                Navigator.pop(context);
              },
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
