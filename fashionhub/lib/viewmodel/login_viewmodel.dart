import 'package:fashionhub/service/authentication_service.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;

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
}
