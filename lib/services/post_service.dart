import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  final CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  Future<void> createPost(String userId, String content) async {
    try {
      await posts.add({
        'userId': userId,
        'username': 'Anonymous',
        'content': content,
        'likes': 0,
        'comments': 0,
        'shares': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getPosts() {
    return posts.orderBy('timestamp', descending: true).snapshots();
  }

  // Add more methods for updating and deleting posts if needed
}
