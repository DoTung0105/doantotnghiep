import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String orderId;
  final String userName;
  final String phone;
  final String deliveryAddress;
  final String imagePath;
  final String productName;
  final String color;
  final String size;
  final String totalPrice;
  final int quantity;
  final double price;
  final double fee;
  final String status;
  final String uid;
  final String paymentMethods;
  final Timestamp orderday;

  Order({
    required this.orderId,
    required this.userName,
    required this.phone,
    required this.deliveryAddress,
    required this.imagePath,
    required this.productName,
    required this.color,
    required this.size,
    required this.totalPrice,
    required this.quantity,
    required this.price,
    required this.fee,
    required this.status,
    required this.uid,
    required this.paymentMethods,
    required this.orderday,
  });

  // Factory constructor to create Order from a map (Firestore document)
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] ?? '',
      userName: map['userName'] ?? '',
      phone: map['phone'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',
      imagePath: map['imagePath'] ?? '',
      productName: map['productName'] ?? '',
      color: map['color'] ?? '',
      size: map['size'] ?? '',
      totalPrice: map['totalPrice'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: map['price']?.toDouble() ?? 0.0,
      fee: map['fee']?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
      uid: map['uid'] ?? '',
      paymentMethods: map['paymentMethods'] ?? '',
      orderday: map['orderday'] ?? Timestamp.now(),
    );
  }
}
