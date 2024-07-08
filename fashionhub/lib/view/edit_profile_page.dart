import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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

        Navigator.pop(context); // Quay lại trang trước đó
      } catch (e) {
        print('Error updating profile: $e');
      }
    }
  }

  Future<String> uploadImage(File file) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${file.uri.pathSegments.last}');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(labelText: 'Display Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your display name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagePathController,
                decoration: InputDecoration(labelText: 'Image Path'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter image path';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
