import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';

class User_Order {
  String orderId;
  String userName;
  String phone;
  String deliveryAddress;
  String imagePath;
  String productName;
  String color;
  String size;
  int quantity;
  double price;
  double fee;
  String status;
  String uid;
  UserModel user;

  User_Order({
    required this.orderId,
    required this.userName,
    required this.phone,
    required this.deliveryAddress,
    required this.imagePath,
    required this.productName,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
    required this.fee,
    required this.status,
    required this.uid,
    required this.user,
  });

  static User_Order fromFirestore(DocumentSnapshot doc, UserModel user) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User_Order(
      orderId: doc.id,
      userName: data['userName'] ?? '',
      phone: data['phone'] ?? '',
      deliveryAddress: data['deliveryAddress'] ?? '',
      imagePath: data['imagePath'] ?? '',
      productName: data['productName'] ?? '',
      color: data['color'] ?? '',
      size: data['size'] ?? '',
      quantity: data['quantity'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      fee: (data['fee'] ?? 0).toDouble(),
      status: data['status'] ?? 'Chờ xác nhận',
      uid: data['uid'] ?? '',
      user: user,
    );
  }
}
