import 'dart:math';

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/products.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
 import 'dart:io';

class ProductViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final Uuid uuid = Uuid();

  String _description = '';
  double _price = 0.0;
  String _size = '';
  File? _image;
  bool _isPickingImage = false;
  String _branch = '';
  List<String> coloroption = ['Red', 'Green', 'Blue', 'Black', 'White'];
  String _color = '';
  String _name = '';
  String _sold = '';

  String get description => _description;
  double get price => _price;
  String get size => _size;
  //them data
  String get branch => _branch;
  String get name => _name;
  String get sold => _sold;
  String get color => _color;

//them data
  File? get image => _image;

//laays sp tu firestore
  late List<Product> _products;
  List<Product> get products => _products;

  Future<List<Product>> getProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();
      List<Product> products = querySnapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return products;
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  // Future<List<Product>> deleteProducs() async{

  // }

  void setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  void setPrice(String price) {
    _price = double.tryParse(price) ?? 0.0;
    notifyListeners();
  }

  void setSize(String size) {
    _size = size;
    notifyListeners();
  }

  void setBranch(String branch) {
    _branch = branch;
    notifyListeners();
  }

  void setColor(String? color) {
    _color = color ?? '';
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setSold(String sold) {
    _sold = sold;
    notifyListeners();
  }

  Future<void> pickImage() async {
    if (_isPickingImage) return;

    _isPickingImage = true;
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        notifyListeners();
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      _isPickingImage = false;
    }
  }

  Future<void> addProduct() async {
    if (_image == null) return;
    try {
      String imageUrl = await uploadImage(_image!);
      DocumentReference docRef =
          await _firestore.collection('products').add(Product(
                  id: "", // Firestore sẽ tự sinh ID mới
                  imageUrl: imageUrl,
                  description: description,
                  price: price,
                  size: size,
                  branch: branch,
                  name: name,
                  sold: sold,
                  color: color)
              .toMap());
      await docRef.update({'id': docRef.id});
      print('Product added successfully');
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
      print('Product deleted successfully');
      //cập nhật lại hiện thị cho người dùng
      _products = await getProducts();
      notifyListeners();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    try {
      await _firestore
          .collection('products')
          .doc(updatedProduct.id)
          .update(updatedProduct.toMap());
      print('Product updated successfully');
      _products = await getProducts();
      notifyListeners();
    } catch (e) {
      print('Error updating product: $e');
    }
  }

   Future<String> uploadImage(File image) async {
    try {
      TaskSnapshot snapshot =
          await _storage.ref().child('products/${uuid.v4()}').putFile(image);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }
 
  void resetImage() {
    _image = null;
    notifyListeners();
  }
}
