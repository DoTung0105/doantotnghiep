import 'package:fashionhub/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class UserService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<UserModel>> getUsers() async {
//     QuerySnapshot snapshot = await _firestore.collection('users').get();
//     return snapshot.docs.map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
//   }

//   Future<void> lockUser(String uid) async {
//     await _firestore.collection('users').doc(uid).update({'locked': true});
//   }

//   Future<void> unlockUser(String uid) async {
//     await _firestore.collection('users').doc(uid).update({'locked': false});
//   }
// }
