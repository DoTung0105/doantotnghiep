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

//tung 22/6
  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProfilePage(currentUser: _currentUser)),
    ).then((_) {
      // Reload user data after returning from the edit page
      _loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ của bạn'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _navigateToEditProfile();
            },
          ),
        ],
      ),
      body: _currentUser == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 5,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(163, 151, 147, 147),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${_currentUser!.email}',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('Tên: ${_currentUser!.displayName}',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('Địa chỉ: ${_currentUser!.address}',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 8),
                        Text('phone: ${_currentUser!.phone}',
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    Column(
                      children: [],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

///màn hình chỉnh sửa

class EditProfilePage extends StatefulWidget {
  final UserModel? currentUser;

  EditProfilePage({required this.currentUser});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _displayNameController =
        TextEditingController(text: widget.currentUser?.displayName);
    _addressController =
        TextEditingController(text: widget.currentUser?.address);
    _phoneController = TextEditingController(text: widget.currentUser?.phone);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Update the user's profile information in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUser?.uid)
          .update({
        'displayName': _displayNameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa hồ sơ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  labelText: 'Tên hiển thị',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên hiển thị';
                  } else if (value.split(' ').length > 5) {
                    return 'Tên hiển thị không được vượt quá 5 từ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black, // Default border color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  } else if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
                    return 'Số điện thoại phải bắt đầu bằng 0 và có đủ 10 chữ số';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Cập nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
