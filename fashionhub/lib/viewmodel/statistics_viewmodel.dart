// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fashionhub/model/user_model.dart';
// import 'package:fashionhub/model/userorder.dart';
// import 'package:intl/intl.dart';

// class StatisticsViewModel extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   int totalOrders = 0;
//   int approvedOrders = 0;
//   int cancelledOrders = 0;
//   double totalRevenue = 0.0;
//   Map<String, UserModel> _users = {};
//   List<User_Order> orders = [];

//   Future<void> fetchStatistics() async {
//     try {
//       await _fetchUsers();

//       final QuerySnapshot result =
//           await _firestore.collection('userOders').get();
//       orders = result.docs.map((doc) {
//         String uid = doc['uid'];
//         UserModel? user = _users[uid];
//         if (user != null) {
//           return User_Order.fromFirestore(doc, user);
//         } else {
//           throw Exception("User not found for uid: $uid");
//         }
//       }).toList();

//       totalOrders = orders.length;
//       approvedOrders = orders.where((order) => order.status == 'Duyệt').length;
//       cancelledOrders =
//           orders.where((order) => order.status == 'Hủy đơn').length;
//       totalRevenue = orders
//           .where((order) => order.status == 'Duyệt')
//           .map((order) => order.price * order.quantity) //tổng doanh thu
//           .fold(0, (prev, amount) => prev + amount);
//       _calculateMonthlyRevenue();
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching statistics: $e");
//     }
//   }

//   Future<void> _fetchUsers() async {
//     final QuerySnapshot userResult = await _firestore.collection('users').get();
//     _users = {
//       for (var doc in userResult.docs)
//         doc.id: UserModel.fromMap(doc.data() as Map<String, dynamic>)
//     };
//   }

// //Thống kê theo tháng
//   Map<String, double> monthlyRevenue = {};
//   void _calculateMonthlyRevenue() {
//     Map<String, double> revenue = {};
//     for (var order in orders) {
//       if (order.status == 'Duyệt') {
//         String month = DateFormat('MM/yyyy').format(order.orderday.toDate());
//         if (revenue.containsKey(month)) {
//           revenue[month] = revenue[month]! + (order.price * order.quantity);
//         } else {
//           revenue[month] = order.price * order.quantity;
//         }
//       }
//     }
//     monthlyRevenue = revenue;
//   }

// //chọn tháng
//   double selectedMonthRevenue = 0.0;
//   void calculateRevenueForSelectedMonth(DateTime selectedMonth) {
//     String monthKey = DateFormat('MM/yyyy').format(selectedMonth);
//     selectedMonthRevenue = monthlyRevenue[monthKey] ?? 0.0;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';
import 'package:fashionhub/model/userorder.dart';
import 'package:intl/intl.dart';

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
      approvedOrders = orders.where((order) => order.status == 'Duyệt').length;
      cancelledOrders =
          orders.where((order) => order.status == 'Hủy đơn').length;
      totalRevenue = orders
          .where((order) => order.status == 'Duyệt')
          .map((order) => order.price * order.quantity)
          .fold(0, (prev, amount) => prev + amount);
      _calculateMonthlyRevenue();
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

  // Thống kê theo tháng
  Map<String, double> monthlyRevenue = {};
  void _calculateMonthlyRevenue() {
    Map<String, double> revenue = {};
    for (var order in orders) {
      if (order.status == 'Duyệt') {
        String month = DateFormat('MM/yyyy').format(order.orderday.toDate());
        if (revenue.containsKey(month)) {
          revenue[month] = revenue[month]! + (order.price * order.quantity);
        } else {
          revenue[month] = order.price * order.quantity;
        }
      }
    }
    monthlyRevenue = revenue;
  }

  // Chọn tháng
  double selectedMonthRevenue = 0.0;
  int selectedMonthApprovedOrders = 0;
  int selectedMonthCancelledOrders = 0;

  void calculateRevenueForSelectedMonth(DateTime selectedMonth) {
    String monthKey = DateFormat('MM/yyyy').format(selectedMonth);
    selectedMonthRevenue = monthlyRevenue[monthKey] ?? 0.0;
    selectedMonthApprovedOrders = orders
        .where((order) =>
            order.status == 'Duyệt' &&
            DateFormat('MM/yyyy').format(order.orderday.toDate()) == monthKey)
        .length;
    selectedMonthCancelledOrders = orders
        .where((order) =>
            order.status == 'Hủy đơn' &&
            DateFormat('MM/yyyy').format(order.orderday.toDate()) == monthKey)
        .length;
    notifyListeners();
  }
}
