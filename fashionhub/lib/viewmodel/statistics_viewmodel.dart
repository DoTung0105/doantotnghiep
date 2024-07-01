// import 'package:fashionhub/model/user_model.dart';
// import 'package:fashionhub/model/userorder.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class StatisticsViewModel extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   int totalOrders = 0;
//   int approvedOrders = 0; //luu don hang thanh cong
//   int cancelledOrders = 0;
//   double totalRevenue = 0.0;
//   Map<String, UserModel> _users = {};
//   List<User_Order> orders = [];
//   Future<void> fetchStatistics() async {
//     try {
//       // Fetch users first to populate _users map
//       await _fetchUsers();

//       final QuerySnapshot result =
//           await _firestore.collection('userOders').get();
//       List<User_Order> orders = result.docs.map((doc) {
//         String uid = doc['uid'];
//         UserModel? user = _users[uid];
//         if (user != null) {
//           return User_Order.fromFirestore(doc, user);
//         } else {
//           throw Exception("User not found for uid: $uid");
//         }
//       }).toList();

//       totalOrders = orders.length;
//       approvedOrders =
//           orders.where((order) => order.status == 'Xác nhận giao hàng').length;
//       cancelledOrders =
//           orders.where((order) => order.status == 'Hủy đơn hàng').length;
//       totalRevenue = orders
//           .where((order) => order.status == 'Xác nhận giao hàng')
//           .map((order) => order.price + order.fee)
//           .reduce((value, element) => value + element);

//       notifyListeners();
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _fetchUsers() async {
//     final QuerySnapshot userResult = await _firestore.collection('users').get();
//     _users = {
//       for (var doc in userResult.docs)
//         doc.id: UserModel.fromMap(doc.data() as Map<String, dynamic>)
//     };
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';
import 'package:fashionhub/model/userorder.dart';

class StatisticsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int totalOrders = 0;
  int approvedOrders = 0;
  int cancelledOrders = 0;
  double totalRevenue = 0.0;
  Map<String, UserModel> _users = {};
  List<User_Order> orders = [];

  Future<void> fetchStatistics() async {
    try {
      await _fetchUsers();

      final QuerySnapshot result =
          await _firestore.collection('userOders').get();
      orders = result.docs.map((doc) {
        String uid = doc['uid'];
        UserModel? user = _users[uid];
        if (user != null) {
          return User_Order.fromFirestore(doc, user);
        } else {
          throw Exception("User not found for uid: $uid");
        }
      }).toList();

      totalOrders = orders.length;
      approvedOrders =
          orders.where((order) => order.status == 'Xác nhận giao hàng').length;
      cancelledOrders =
          orders.where((order) => order.status == 'Hủy đơn hàng').length;
      totalRevenue = orders
          .where((order) => order.status == 'Xác nhận giao hàng')
          .map((order) => order.price + order.fee)
          .fold(0, (prev, amount) => prev + amount);

      notifyListeners();
    } catch (e) {
      print("Error fetching statistics: $e");
    }
  }

  Future<void> _fetchUsers() async {
    final QuerySnapshot userResult = await _firestore.collection('users').get();
    _users = {
      for (var doc in userResult.docs)
        doc.id: UserModel.fromMap(doc.data() as Map<String, dynamic>)
    };
  }

  // void approveOrder(User_Order order) {
  //   fetchStatistics();
  // }

  // void cancelOrder(User_Order order) {
  //   fetchStatistics();
  // }
}
