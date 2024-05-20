import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkEmailExists(String email) async {
    try {
      // Kiểm tra xem email đã tồn tại trong Firestore hay chưa
      var querySnapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();
      
      // Nếu có bất kỳ tài khoản nào sử dụng email này, trả về true
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error checking email existence: $e');
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
