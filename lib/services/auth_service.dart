// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final CollectionReference users = FirebaseFirestore.instance.collection('users');

//   Future<User?> signInAnonymously() async {
//     try {
//       UserCredential userCredential = await _auth.signInAnonymously();
//       User? user = userCredential.user;

//       // Create user profile if not exists
//       if (user != null) {
//         DocumentSnapshot doc = await users.doc(user.uid).get();
//         if (!doc.exists) {
//           await users.doc(user.uid).set({
//             'username': 'Anonymous',
//             'createdAt': FieldValue.serverTimestamp(),
//           });
//         }
//       }
//       return user;
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
// }
