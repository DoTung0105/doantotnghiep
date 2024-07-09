import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';
import 'package:fashionhub/model/userorder.dart' as userOrderModel;
import 'package:fashionhub/service/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final String status;

  const OrderItem({Key? key, required this.status}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthenticationService _authenticationService = AuthenticationService();

  List<userOrderModel.User_Order> _orders = [];
  Map<String, UserModel> _users = {};

  List<userOrderModel.User_Order> get orders => _orders;

  UserModel? getUserById(String uid) => _users[uid];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      User? currentUser = _authenticationService.getCurrentUser();
      if (currentUser == null) {
        print('User is not logged in');
        return;
      }
      String uid = currentUser.uid;
      // Fetch orders based on the current user's uid and status
      final QuerySnapshot orderResult = await _firestore
          .collection('userOrders')
          .where('uid', isEqualTo: uid)
          .where('status', isEqualTo: widget.status)
          .get();

      // Fetch all users (assuming you want to get all users initially)
      final QuerySnapshot userResult =
          await _firestore.collection('users').get();

      // Convert user documents to a map of userId -> UserModel
      _users = {
        for (var doc in userResult.docs)
          doc.id: UserModel.fromMap(doc.data() as Map<String, dynamic>)
      };

      // Map orders and include user information
      _orders = orderResult.docs.map((doc) {
        String uid = doc['uid'];
        UserModel? user = _users[uid];
        if (user != null) {
          return userOrderModel.User_Order.fromFirestore(doc, user);
        } else {
          // Handle case where user does not exist
          return userOrderModel.User_Order(
            orderId: doc.id,
            userName: doc['userName'] ?? '',
            phone: doc['phone'] ?? '',
            deliveryAddress: doc['deliveryAddress'] ?? '',
            deliveryTime: doc['deliveryTime'] ?? '',
            products: (doc['products'] as List<dynamic>)
                .map((product) => userOrderModel.OrderProduct.fromMap(product))
                .toList(),
            totalPrice: doc['totalPrice'] ?? '',
            fee: (doc['fee'] ?? 0).toDouble(),
            status: doc['status'] ?? 'Chờ xác nhận',
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

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  String formatPrice(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return formatter.format(price).trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          userOrderModel.User_Order order = _orders[index];
          return Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mã vận đơn: ${order.orderId}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Ngày giao dự kiến: ${order.deliveryTime}'),
                ...order.products.map(
                  (product) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        // Hiển thị hình ảnh sản phẩm nếu có
                        Image.network(
                          product
                              .imagePath, // Thay đổi thành đường dẫn hình ảnh thực tế
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(product.productName),
                                  Row(
                                    children: [
                                      Text('${product.color},'),
                                      Text(product.size),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('${formatPrice(product.price)}đ'),
                                  SizedBox(width: 40),
                                  Text('x${product.quantity}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Thanh toán: ${order.totalPrice}',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
