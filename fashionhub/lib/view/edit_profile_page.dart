import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chỉnh sửa hồ sơ'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Center(
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
                        child: Image.asset(
                          'lib/images/user.png',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(height: 5),
              Center(
                child: SizedBox(
                  width: 100,
                  height: 25,
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    child: Icon(Icons.camera_alt_outlined),
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
