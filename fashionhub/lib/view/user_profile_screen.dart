import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/model/user_model.dart';

class ProfilePage extends StatefulWidget {
  final AuthenticationService authService;

  ProfilePage({required this.authService});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = widget.authService.getCurrentUser();
    if (user != null) {
      DocumentSnapshot userDoc =
          await widget.authService.getUserDetails(user.uid);
      if (userDoc.exists) {
        setState(() {
          _currentUser =
              UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        });
      } else {
        print("No user data found");
      }
    } else {
      print("No user logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ của bạn'),
      ),
      body: _currentUser == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Email: ${_currentUser!.email}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Tên hiển thị: ${_currentUser!.displayName}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Địa chỉ: ${_currentUser!.address}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('phone: ${_currentUser!.phone}',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
    );
  }
}
