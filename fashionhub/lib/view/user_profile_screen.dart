import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/components/layout_widget.dart';
import 'package:fashionhub/components/order_list.dart';
import 'package:fashionhub/model/user_model.dart';
import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/edit_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  void _navigateToEditProfile() {
    if (_currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfilePage(currentUser: _currentUser!)),
      ).then((_) {
        // Reload user data after returning from the edit page
        _loadUserData();
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (_currentUser != null) {
          _currentUser!.imagePath = pickedFile.path;
        }
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Xin chào ${_currentUser?.displayName ?? ''}!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple.shade200],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              height: 150,
            ),
          ),
          _currentUser == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const SizedBox(height: 30),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 58,
                        backgroundImage: _currentUser!.imagePath != null &&
                                _currentUser!.imagePath!.isNotEmpty
                            ? (_currentUser!.imagePath!.startsWith('http')
                                    ? NetworkImage(_currentUser!.imagePath!)
                                    : FileImage(File(_currentUser!.imagePath!)))
                                as ImageProvider
                            : AssetImage('lib/images/placeholder.png'),
                      ),
                    ),
                    const SizedBox(height: 3),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.44,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        child: const Row(
                          children: [
                            Text('Thay ảnh đại diện'),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.edit,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey)),
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ProfileItem(
                                  icon: Icons.person_2_outlined,
                                  text: _currentUser!.displayName ?? ''),
                              Divider(),
                              ProfileItem(
                                  icon: Icons.email_outlined,
                                  text: _currentUser!.email),
                              Divider(),
                              ProfileItem(
                                  icon: Icons.phone_outlined,
                                  text: _currentUser!.phone ?? ''),
                              Divider(),
                              ProfileItem(
                                  icon: Icons.home_outlined,
                                  text: _currentUser!.address ?? ''),
                              Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Đơn hàng của bạn',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 300, // Adjust this height as needed
                                child: OrderList(),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple,
                              Colors.purple.shade300,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: _navigateToEditProfile,
                          child: Text(
                            'Chỉnh sửa trang cá nhân',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
