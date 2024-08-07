import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/products.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ProductViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final Uuid uuid = Uuid();

  String _description = '';
  double _price = 0.0;
  double _evaluate = 0.0;

  String _size = '';
  File? _image;
  bool _isPickingImage = false;
  String _branch = '';
  //List<String> coloroption = ['Red', 'Green', 'Blue', 'Black', 'White'];
  List<String> sizeoption = ['M', 'L', 'XL'];
  String _color = '';
  String _name = '';
  int _sold = 0; // 11.6 - Thịnh gán giá trị mặc định cho sold
  String _wareHouse = '';

  String get description => _description;
  double get price => _price;

  double get evaluate => _evaluate; // tung them 13/6

  String get size => _size;
  //them data
  String get branch => _branch;
  String get name => _name;
  int get sold => _sold;
  String get color => _color;
  String get wareHouse => _wareHouse;

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
    // _price = double.tryParse(price) ?? 0.0;
    final cleanedPrice = price.replaceAll(RegExp(r'[^0-9.]'), '');
    _price = double.tryParse(cleanedPrice) ?? 0.0;
    notifyListeners();
  }

  String getFormattedPrice() {
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(_price);
  }

  void setEvaluate(String evaluate) {
    _evaluate = double.tryParse(evaluate) ?? 0.0;
  }

  void setSize(String? size) {
    _size = size ?? '';
    notifyListeners();
  }

  void setBranch(String branch) {
    _branch = branch;
    notifyListeners();
  }

  void setColor(String color) {
    _color = color;
    notifyListeners();
  }
  // void setColor(String? color) {
  //   _color = color ?? '';
  //   notifyListeners();
  // }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setSold(int sold) {
    _sold = sold;
    notifyListeners();
  }

  void setWarehouse(String warehouse) {
    _wareHouse = warehouse;
    notifyListeners();
  }

  Future<void> pickImage() async {
    if (_isPickingImage) return;

    _isPickingImage = true;
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
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
                imagePath: imageUrl,
                description: description,
                price: price,
                //price:double.tryParse(_price.toString()) ?? 0.0,
                size: size,
                brand: branch,
                name: name,
                sold: sold, // 11.6 - Thịnh sửa lại kiểu dl cho sold
                color: color,
                evaluate: evaluate,
                wareHouse: int.parse(
                    wareHouse), // 11.6 - Thịnh sửa lại kiểu dl cho wareHouse
              ).toMap());
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

  void resetFields() {
    _description = '';
    _price = 0.0; // Đặt lại giá trị price về 0.0
    _size = '';
    _branch = '';
    _color = '';
    _name = '';
    _sold = 0; // 11.6 - Thịnh gán giá trị mặc định cho sold
    _wareHouse = '';
    _image = null;
    //_evaluate = 0.0;
    notifyListeners();
  }

  void resetImage() {
    _image = null;
    notifyListeners();
  }
}
