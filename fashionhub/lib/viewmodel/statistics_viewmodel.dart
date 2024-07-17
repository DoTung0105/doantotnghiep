import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';
import 'package:fashionhub/model/userorder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatisticsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int totalOrders = 0;
  int success = 0;
  int shipping = 0;
  int cancelledOrders = 0;
  int pendingOrders = 0;
  double totalRevenue = 0.0;
  Map<String, UserModel> _users = {};
  List<User_Order> orders = [];

  Future<void> fetchStatistics() async {
    try {
      await _fetchUsers();

      final QuerySnapshot result =
          await _firestore.collection('userOrders').get();
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
      cancelledOrders =
          orders.where((order) => order.status == 'Đã hủy').length;
      success = orders.where((order) => order.status == 'Thành công').length;
      shipping = orders.where((order) => order.status == 'Đang giao').length;

      pendingOrders = orders
          .where((order) => order.status == 'Chờ xác nhận')
          .length; // Tính số lượng đơn hàng chờ xác nhận
      totalRevenue =
          orders.where((order) => order.status == 'Thành công').map((order) {
        String cleanedPrice = order.totalPrice.replaceAll(RegExp(r'[^\d]'), '');
        double price = double.tryParse(cleanedPrice) ?? 0.0;
        double fee = order.fee; // Lấy phí vận chuyển từ đơn hàng
        double netPrice = price - fee; // Trừ phí vận chuyển khỏi tổng giá

        print(
            "Order ID: ${order.orderId}, Total Price (String): ${order.totalPrice}, Cleaned Price: $cleanedPrice, Parsed Price (Double): $price");
        return netPrice;
      }).fold(0.0, (prev, amount) => prev + amount);

      _calculateMonthlyRevenue();
      //  calculateQuarterlyStatistics();
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
      if (order.status == 'Thành công') {
        String month = DateFormat('MM/yyyy').format(order.orderday.toDate());
        String cleanedPrice = order.totalPrice.replaceAll(RegExp(r'[^\d]'), '');
        double totalPrice = double.tryParse(cleanedPrice) ?? 0.0;
        print(
            "Order ID: ${order.orderId}, Month: $month, Total Price (String): ${order.totalPrice}, Cleaned Price: $cleanedPrice, Parsed Price (Double): $totalPrice");
        if (revenue.containsKey(month)) {
          revenue[month] = revenue[month]! + (totalPrice - order.fee);
        } else {
          revenue[month] = totalPrice - order.fee;
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
            order.status == 'Thành công' &&
            DateFormat('MM/yyyy').format(order.orderday.toDate()) == monthKey)
        .length;
    selectedMonthCancelledOrders = orders
        .where((order) =>
            order.status == 'Đã hủy' &&
            DateFormat('MM/yyyy').format(order.orderday.toDate()) == monthKey)
        .length;
    notifyListeners();
  }

  List<MonthlyRevenue> getMonthlyRevenueData() {
    return monthlyRevenue.entries
        .map((entry) => MonthlyRevenue(entry.key, entry.value))
        .toList();
  }

  // Thống kê theo quý
  Map<String, double> quarterlyRevenue = {};
  int quarterlyApprovedOrders = 0;
  int quarterlyCancelledOrders = 0;

  void calculateQuarterlyStatistics(int year, String selectedQuarter) {
    // Filter orders for the selected year and quarter
    List<User_Order> filteredOrders = orders.where((order) {
      DateTime orderDate = order.orderday.toDate();
      return orderDate.year == year &&
          _getQuarterFromDate(orderDate) == selectedQuarter;
    }).toList();

    // Calculate revenue and order counts
    double totalRevenue = 0.0;
    int approvedOrders = 0;
    int cancelledOrders = 0;

    for (var order in filteredOrders) {
      if (order.status == 'Thành công') {
        String cleanedPrice = order.totalPrice.replaceAll(RegExp(r'[^\d]'), '');
        double totalPrice = double.tryParse(cleanedPrice) ?? 0.0;
        totalRevenue += (totalPrice - order.fee);
        approvedOrders++;
      } else if (order.status == 'Đã hủy') {
        cancelledOrders++;
      }
    }

    quarterlyRevenue[selectedQuarter] = totalRevenue;
    quarterlyApprovedOrders = approvedOrders;
    quarterlyCancelledOrders = cancelledOrders;

    notifyListeners();
  }

  String _getQuarterFromDate(DateTime date) {
    int month = date.month;
    if (month >= 1 && month <= 3) {
      return '1';
    } else if (month >= 4 && month <= 6) {
      return '2';
    } else if (month >= 7 && month <= 9) {
      return '3';
    } else {
      return '4';
    }
  }

  List<QuarterlyRevenue> getQuarterlyRevenueData() {
    return quarterlyRevenue.entries
        .map((entry) => QuarterlyRevenue(entry.key, entry.value))
        .toList();
  }

  // Thống kê theo năm
  Map<int, double> yearlyRevenue = {};

  void calculateYearlyRevenue(int year) {
    double totalRevenue = 0.0;
    for (var order in orders) {
      if (order.status == 'Thành công' &&
          order.orderday.toDate().year == year) {
        String cleanedPrice = order.totalPrice.replaceAll(RegExp(r'[^\d]'), '');
        double totalPrice = double.tryParse(cleanedPrice) ?? 0.0;
        totalRevenue += (totalPrice - order.fee);
      }
    }
    yearlyRevenue[year] = totalRevenue;
    notifyListeners();
  }
}

class MonthlyRevenue {
  final String month;
  final double revenue;

  MonthlyRevenue(this.month, this.revenue);
}

class QuarterlyRevenue {
  final String quarter;
  final double revenue;

  QuarterlyRevenue(this.quarter, this.revenue);
}
