import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';

class OrderProduct {
  String imagePath;
  String productName;
  String color;
  String size;
  int quantity;
  double price;

  OrderProduct({
    required this.productName,
    required this.imagePath,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
  });

  factory OrderProduct.fromMap(Map<String, dynamic> map) {
    return OrderProduct(
      productName: map['productName'] ?? '',
      imagePath: map['imagePath'] ?? '',
      color: map['color'] ?? '',
      size: map['size'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
    );
  }
}

class User_Order {
  String orderId;
  String userName;
  String phone;
  String deliveryAddress;
  List<OrderProduct> products;
  String totalPrice;
  double fee;
  String status;
  String uid;
  UserModel user;
  Timestamp orderday;

  User_Order({
    required this.orderId,
    required this.userName,
    required this.phone,
    required this.deliveryAddress,
    required this.products,
    required this.totalPrice,
    required this.fee,
    required this.status,
    required this.uid,
    required this.user,
    required this.orderday,
  });

  static User_Order fromFirestore(DocumentSnapshot doc, UserModel user) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<OrderProduct> products = (data['products'] as List<dynamic>)
        .map((item) => OrderProduct.fromMap(item))
        .toList();
    return User_Order(
      orderId: doc.id,
      userName: data['userName'] ?? '',
      phone: data['phone'] ?? '',
      deliveryAddress: data['deliveryAddress'] ?? '',
      totalPrice: data['totalPrice'] ?? '',
      products: products,
      fee: (data['fee'] ?? 0).toDouble(),
      status: data['status'] ?? 'Chờ xác nhận',
      uid: data['uid'] ?? '',
      user: user,
      orderday: data['orderday'],
    );
  }
}
