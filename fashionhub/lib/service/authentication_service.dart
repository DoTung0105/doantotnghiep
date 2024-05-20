import 'dart:convert';

import 'package:fashionhub/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   //final String _emailValidationApiKey = '1ef80c1476ca43808c17fdd9d6ca66c2';

  //kiểm tra định dạng mail
     Future<bool> isEmailValid(String email) async {
    return email.contains('@') && email.endsWith('@gmail.com');
  }


  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String displayName, String address) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        UserModel newUser = UserModel(
            uid: user.uid,
            email: email,
            displayName: displayName,
            address: address);
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        
        // Gửi email xác nhận
        await user.sendEmailVerification();
      }

      return user;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await _firebaseAuth.signOut();
        throw FirebaseAuthException(
            code: 'email-not-verified',
            message: 'Please verify your email before signing in.');
      }

      return user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }


  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}

