import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;

  SignUpViewModel({required AuthenticationService authenticationService})
      : _authenticationService = authenticationService;

  Future<User?> signUp(
      String email, String password, String displayName, String address,String phone) async {
    try {
      return await _authenticationService.signUpWithEmailAndPassword(
          email, password, displayName, address,phone);
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  //kiểm tra định dạng mail
   Future<bool> isEmailValid(String email) async {
    return await _authenticationService.isEmailValid(email);
  }



}
