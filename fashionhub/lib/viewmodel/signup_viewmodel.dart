import 'dart:io';

import 'package:fashionhub/service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;

  SignUpViewModel({required AuthenticationService authenticationService})
      : _authenticationService = authenticationService;

  Future<User?> signUp(String email, String password, String displayName) async {
    try {
      return await _authenticationService.signUpWithEmailAndPassword(email, password, displayName);
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }
}
