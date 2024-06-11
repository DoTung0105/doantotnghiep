import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<bool> isEmailValid(String email) async {
    return email.contains('@') && email.endsWith('@gmail.com') ||
        email.endsWith('@gmail.com.vn');
  }

  // Future<User?> signUpWithEmailAndPassword(String email, String password,
  //     String displayName, String address, String phone) async {
  //   try {
  //     UserCredential userCredential = await _firebaseAuth
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //     User? user = userCredential.user;

  //     if (user != null) {
  //       UserModel newUser = UserModel(
  //           uid: user.uid,
  //           email: email,
  //           displayName: displayName,
  //           address: address,
  //           password: password,
  //           phone: phone);
  //       await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

  //       await user.sendEmailVerification();
  //     }

  //     return user;
  //   } catch (e) {
  //     print("Error signing up: $e");
  //     return null;
  //   }
  // }

  Future<bool> isEmailAlreadyInUse(String email) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password:
            'randomPassword', // Dùng một mật khẩu tạm thời để kiểm tra tồn tại email
      );
      // Nếu không có lỗi xảy ra, tức là email chưa được sử dụng
      await userCredential.user?.delete(); // Xóa người dùng tạo ra để kiểm tra

      return false;
    } on FirebaseAuthException catch (e) {
      // Nếu xảy ra lỗi 'email-already-in-use', tức là email đã tồn tại
      if (e.code == 'email-already-in-use') {
        return true;
      } else {
        // Xử lý các lỗi khác nếu cần
        print('Error: $e');
        return false;
      }
    } catch (e) {
      // Xử lý các lỗi khác nếu cần
      print('Error: $e');
      return false;
    }
  }

  Future<User?> signUpWithEmailAndPassword(
      String email,
      String password,
      String displayName,
      String address,
      String phone,
      String role,
      bool locked) async {
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
            password: password,
            phone: phone,
            role: role,
            locked: false);
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

        await user.sendEmailVerification();
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Nếu email đã được sử dụng, đưa ra thông báo cho người dùng
        throw FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email đã được sử dụng.',
        );
      } else {
        // Nếu có lỗi khác, xử lý theo cách bạn muốn ở đây
        throw FirebaseAuthException(
          code: e.code,
          message: e.message,
        );
      }
    } catch (e) {
      print("Lỗi đăng ký: $e");
      throw Exception("Lỗi đăng ký không xác định.");
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

//update sau khi quên mật khẩu, đăng nhập băng mk mới sẽ update lên firestore
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

  Future<DocumentSnapshot> getUserDetails(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  // thêm phương thức lấy vai trò người dùng 11/6
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      return userDoc['role'] as String?;
    } catch (e) {
      print("Error getting user role: $e");
      return null;
    }
  }
}
