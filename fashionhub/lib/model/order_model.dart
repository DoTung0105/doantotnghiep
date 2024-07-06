import 'package:cloud_firestore/cloud_firestore.dart';

class Order_class {
  final String orderId;
  String userName;
  String phone;
  String deliveryAddress;
  final String imagePath;
  final String productName;
  final String color;
  final String size;
  String totalPrice;
  final int quantity;
  final double price;
  double fee;
  String status;
  final String uid;
  String paymentMethods;
  final Timestamp orderday;

  Order_class({
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
  factory Order_class.fromMap(Map<String, dynamic> map) {
    return Order_class(
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
      status: map['status'] ?? 'Chờ xác nhận',
      uid: map['uid'] ?? '',
      paymentMethods: map['paymentMethods'] ?? 'Thanh toán khi nhận hàng',
      orderday: map['orderday'] ?? Timestamp.now(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userName': userName,
      'phone': phone,
      'deliveryAddress': deliveryAddress,
      'imagePath': imagePath,
      'productName': productName,
      'color': color,
      'size': size,
      'totalPrice': totalPrice,
      'quantity': quantity,
      'price': price,
      'fee': fee,
      'status': status,
      'uid': uid,
      'paymentMethods': paymentMethods,
      'orderday': orderday,
    };
  }
}
