import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';
import 'package:fashionhub/model/userorder.dart';
import 'package:flutter/material.dart';

class User_Order_ViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<User_Order> _orders = [];
  Map<String, UserModel> _users = {};

  List<User_Order> get orders => _orders;

  UserModel? getUserById(String uid) => _users[uid];

  Future<void> fetchOrders() async {
    try {
      final QuerySnapshot orderResult =
          await _firestore.collection('userOrders').get();
      final QuerySnapshot userResult =
          await _firestore.collection('users').get();

      _users = {
        for (var doc in userResult.docs)
          doc.id: UserModel.fromMap(doc.data() as Map<String, dynamic>)
      };

      _orders = orderResult.docs.map((doc) {
        String uid = doc['uid'];
        UserModel? user = _users[uid];
        if (user != null) {
          return User_Order.fromFirestore(doc, user);
        } else {
          // Xử lý khi user không tồn tại
          return User_Order(
            orderId: doc.id,
            userName: doc['userName'] ?? '',
            phone: doc['phone'] ?? '',
            deliveryAddress: doc['deliveryAddress'] ?? '',
            deliveryTime: doc['deliveryTime'] ?? '',
            products: (doc['products'] as List<dynamic>)
                .map((product) => OrderProduct.fromMap(product))
                .toList(),
            totalPrice: doc['totalPrice'] ?? '',
            fee: (doc['fee'] ?? 0).toDouble(),
            status: doc['status'] ?? 'Chờ xác nhận',
            paymentMethods: doc['paymentMethods'] ?? 'Thanh toán khi nhận hàng',
            uid: uid,
            orderday: doc['orderday'],
            user: UserModel(
              uid: uid,
              email: '',
              displayName: 'Unknown User',
              address: '',
              password: '',
              phone: '',
              role: '',
              imagePath: '',
            ),
          );
        }
      }).toList();

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore
          .collection('userOrders')
          .doc(orderId)
          .update({'status': status});
      await fetchOrders(); // Cập nhật lại danh sách đơn hàng sau khi thay đổi trạng thái
    } catch (e) {
      print(e);
    }
  }
}
