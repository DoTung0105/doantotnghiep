import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/viewmodel/user_ViewModel.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;
  UsersViewModel _usersViewModel = UsersViewModel();

  LoginViewModel({required AuthenticationService authenticationService})
      : _authenticationService = authenticationService;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _authenticationService.signInWithEmailAndPassword(
          email, password);
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
   }

  // Future<User?> signInWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     User? user = await _authenticationService.signInWithEmailAndPassword(
  //         email, password);
  //     if (user != null) {
  //       // Kiểm tra xem tài khoản có bị khóa không
  //       bool locked = await isAccountLocked(user.uid);
  //       if (locked) {
  //         // Hiển thị thông báo nếu tài khoản bị khóa
  //         throw 'Tài khoản này đã bị khóa';
  //       }
  //     }
  //     return user;
  //   } catch (e) {
  //     print("Error signing in: $e");
  //     throw e; // Ném lại lỗi để xử lý ở phần gọi signInWithEmailAndPassword
  //   }
  // }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _authenticationService.signOut();
  }

  User? getCurrentUser() {
    return _authenticationService.getCurrentUser();
  }

  Future<bool> isLoggedIn() async {
    return await _authenticationService.isLoggedIn();
  }

  Future<bool> isAccountLocked(String uid) async {
    try {
      // Lấy dữ liệu người dùng từ Firestore
      var userData = await _usersViewModel.getUserData(uid);
      // Kiểm tra xem trạng thái khóa của tài khoản
      return userData?['locked'] ?? false;
    } catch (e) {
      print('Error checking account lock: $e');
      return false;
    }
  }
}
