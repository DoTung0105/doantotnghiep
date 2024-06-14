import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';

class UsersViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        userData['uid'] = doc.id; // Thêm uid vào dữ liệu user

        return UserModel.fromMap(userData);
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<void> lockOrUnlockUser(String uid, bool lock) async {
    try {
      await _firestore.collection('users').doc(uid).update({'locked': lock});
    } catch (e) {
      print('Error ${lock ? 'locking' : 'unlocking'} user: $e');
    }
  }

  // Lấy dữ liệu người dùng từ Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      return snapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
