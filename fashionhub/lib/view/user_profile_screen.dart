import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/model/user_model.dart';
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
      ),
      body: _currentUser == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: _currentUser!.imagePath != null &&
                                _currentUser!.imagePath!.isNotEmpty
                            ? Image.network(
                                _currentUser!.imagePath!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.person,
                                size: 100,
                              ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Thông tin cá nhân',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email:        ${_currentUser!.email}',
                            style: TextStyle(fontSize: 18)),
                        Divider(
                          thickness: 1,
                        ),
                        Text('Tên:           ${_currentUser!.displayName}',
                            style: TextStyle(fontSize: 18)),
                        Divider(
                          thickness: 1,
                        ),
                        Text('Địa chỉ:      ${_currentUser!.address}',
                            style: TextStyle(fontSize: 18)),
                        Divider(
                          thickness: 1,
                        ),
                        Text('Điện thoại: ${_currentUser!.phone}',
                            style: TextStyle(
                              fontSize: 18,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 150),
                              ),
                              onPressed: _navigateToEditProfile,
                              child: Text(
                                'Chỉnh sửa',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                      ],
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
  late TextEditingController _imagePathController;

  @override
  void initState() {
    super.initState();
    _displayNameController =
        TextEditingController(text: widget.currentUser?.displayName);
    _addressController =
        TextEditingController(text: widget.currentUser?.address);
    _phoneController = TextEditingController(text: widget.currentUser?.phone);
    _imagePathController =
        TextEditingController(text: widget.currentUser?.imagePath ?? '');
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        String imagePath = _imagePathController.text;
        String? downloadURL;
        // Check if user selected a new image
        if (imagePath.isNotEmpty &&
            !(imagePath.startsWith('http') || imagePath.startsWith('https'))) {
          // Upload image to Firebase Storage
          downloadURL = await uploadImage(File(imagePath));
          // Update user profile with new image URL
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.currentUser?.uid)
              .update({
            'displayName': _displayNameController.text,
            'address': _addressController.text,
            'phone': _phoneController.text,
            'image': downloadURL,
          });
        } else {
          // Update user profile without changing image URL
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.currentUser?.uid)
              .update({
            'displayName': _displayNameController.text,
            'address': _addressController.text,
            'phone': _phoneController.text,
          });
        }

        // Cập nhật thông tin người dùng hiện tại
        setState(() {
          widget.currentUser!.displayName = _displayNameController.text;
          widget.currentUser!.address = _addressController.text;
          widget.currentUser!.phone = _phoneController.text;
          if (downloadURL != null) {
            widget.currentUser!.imagePath = downloadURL;
          }
        });

        Navigator.pop(context);
      } catch (e) {
        print('Error updating profile: $e');
        // Handle error as needed
      }
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      // Create a reference to the storage
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('avatars/${widget.currentUser?.uid}.jpg');
      // Upload the file
      await storageRef.putFile(image);
      // Return the URL of the uploaded file
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imagePathController.text = pickedFile.path;
      });
    } else {
      print('No image selected.');
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
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: _imagePathController.text.isNotEmpty
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              _imagePathController.text.startsWith('http')
                                  ? NetworkImage(_imagePathController.text)
                                  : FileImage(File(_imagePathController.text))
                                      as ImageProvider,
                        )
                      : CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person),
                        ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  labelText: 'Tên hiển thị',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
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
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
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
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
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
