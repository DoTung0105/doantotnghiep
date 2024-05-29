import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

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
            address: address,
            password: password
            );
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        
        await user.sendEmailVerification();
      }

      return user;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
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

      if (user != null) {
        await _saveLoggedInState(true);
      }

      return user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _saveLoggedInState(false);
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> _saveLoggedInState(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

   Future<void> updatePassword(String newPassword) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);

      // Cập nhật mật khẩu trong Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'password': newPassword,
      });
    }
  }
}
