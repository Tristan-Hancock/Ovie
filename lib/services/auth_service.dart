import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
Future<void> joinCommunity(String communityId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await users.doc(user.uid).update({
        'joinedCommunities': FieldValue.arrayUnion([communityId])
      });
    }
  }
   Future<void> leaveCommunity(String communityId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await users.doc(user.uid).update({
        'joinedCommunities': FieldValue.arrayRemove([communityId])
      });
    }
  }
   Future<QuerySnapshot> getJoinedCommunities() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await users.doc(user.uid).get();
      List joinedCommunities = userDoc['joinedCommunities'] ?? [];
      return FirebaseFirestore.instance
          .collection('communities')
          .where(FieldPath.documentId, whereIn: joinedCommunities)
          .get();
    }
    return FirebaseFirestore.instance.collection('communities').get();
  }
    Future<bool> isCommunityJoined(String communityId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await users.doc(user.uid).get();
      List joinedCommunities = userDoc['joinedCommunities'] ?? [];
      return joinedCommunities.contains(communityId);
    }
    return false;
  }
  Future<User?> signUpWithEmail(String email, String password, String username) async {
    try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredential.user;

        // Create user profile with username
        if (user != null) {
            await users.doc(user.uid).set({
                'username': username, // Include the username field
                'email': email,
                'createdAt': FieldValue.serverTimestamp(), // Timestamp for when the user was created
            });
        }
        return user;
    } catch (e) {
        print("Error during sign-up: ${e.toString()}");
        return null;
    }
}


  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Create user profile if not exists
      if (user != null) {
        DocumentSnapshot doc = await users.doc(user.uid).get();
        if (!doc.exists) {
          await users.doc(user.uid).set({
            'username': user.displayName ?? 'Google User',
            'email': user.email,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;

      // Create user profile if not exists
      if (user != null) {
        DocumentSnapshot doc = await users.doc(user.uid).get();
        if (!doc.exists) {
          await users.doc(user.uid).set({
            'username': 'Anonymous',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future<User?> signOut( ) async{
    try {
      await _auth.signOut();
  }catch (e) {
    print(e.toString());
  }
}
}