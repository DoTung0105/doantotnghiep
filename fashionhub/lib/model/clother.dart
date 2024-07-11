import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Clother with ChangeNotifier {
  final String id;
  final String name;
  final double price;
  final String imagePath;
  final String description;
  final String brand;
  final String color;
  final String size;
  final double evaluate;
  int _sold;
  int _wareHouse; // Thêm _wareHouse
  final int quantity;

  Clother({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.brand,
    required this.color,
    required this.size,
    required this.evaluate,
    required int sold,
    required int wareHouse, // Thêm wareHouse vào đây
    this.quantity = 1,
  })  : _sold = sold,
        _wareHouse = wareHouse {
    _loadSold();
    _loadWareHouse(); // Gọi hàm _loadWareHouse khi khởi tạo
  }

  int get sold => _sold;
  int get wareHouse => _wareHouse;

  void _loadSold() {
    FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _sold = snapshot.data()?['sold'] ?? 0;
        notifyListeners();
      }
    });
  }

  void _loadWareHouse() {
    FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _wareHouse = snapshot.data()?['wareHouse'] ?? 0;
        notifyListeners();
      }
    });
  }
}
