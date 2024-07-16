import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/user_model.dart';
import 'package:fashionhub/model/userorder.dart' as userOrderModel;
import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

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

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  String formatPrice(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '');
    return formatter.format(price).trim();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore
          .collection('userOrders')
          .doc(orderId)
          .update({'status': status});
      print('Đã cập nhật trạng thái đơn hàng thành công');
      // Sau khi cập nhật, cần gọi fetchOrders() để cập nhật lại danh sách đơn hàng
      fetchOrders();
    } catch (e) {
      print('Lỗi khi cập nhật trạng thái đơn hàng: $e');
      // Xử lý lỗi khi cập nhật trạng thái
    }
  }

  void _showDialogHuyDon(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Lottie.asset(
            'assets/animation_sad.json',
            width: 250,
            height: 250,
          ),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black))),
            child: Text(
              "Bạn có chắc chắn muốn hủy đơn hàng này?",
              style: TextStyle(fontSize: 17),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
            TextButton(
              child: Text("Xác nhận"),
              onPressed: () {
                // Thực hiện hành động hủy đơn
                updateOrderStatus(orderId, 'Đã hủy');
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogDatLai(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.all(10),
          actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Column(
            children: [
              Image.asset(
                'lib/images/checkOrder.png',
                width: 60,
                height: 60,
              ),
            ],
          ),
          content: Text(
            'Đặt hàng thành công!',
            style: TextStyle(color: Colors.green, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 70,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Đóng',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          userOrderModel.User_Order order = _orders[index];

          // Chỉ hiển thị nút "Hủy đơn" khi status là 'Chờ xác nhận' hoặc 'Đang giao'
          bool showCancelButton =
              order.status == 'Chờ xác nhận' || order.status == 'Đang giao';

          // Chỉ hiển thị nút "Đặt lại" khi status là 'Đã hủy'
          bool showResetButton = order.status == 'Đã hủy';

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
                          product.imagePath,
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
                                  Text(
                                    '${product.productName.length > 25 ? product.productName.substring(0, 25) + '...' : product.productName}',
                                  ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thanh toán: ${order.totalPrice}',
                      style: TextStyle(color: Colors.red),
                    ),
                    if (showCancelButton) // Chỉ hiển thị nút "Hủy đơn" khi điều kiện đúng
                      GestureDetector(
                        onTap: () {
                          _showDialogHuyDon(context, order.orderId);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: Colors.grey[200], // Màu nền xám nhạt
                            borderRadius:
                                BorderRadius.circular(8), // Bo góc container
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Màu bóng và độ mờ
                                spreadRadius: 1, // Độ lan rộng của bóng
                                blurRadius: 4, // Độ mờ của bóng
                                offset:
                                    Offset(-1, 3), // Độ dịch chuyển của bóng
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Hủy đơn',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (showResetButton) // Hiển thị nút "Đặt lại" khi điều kiện đúng
                      GestureDetector(
                        onTap: () {
                          // Cập nhật trạng thái đơn hàng thành "Chờ xác nhận"
                          updateOrderStatus(order.orderId, 'Chờ xác nhận');
                          _showDialogDatLai(context, order.orderId);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: Colors.grey[200], // Màu nền xám nhạt
                            borderRadius:
                                BorderRadius.circular(8), // Bo góc container
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Màu bóng và độ mờ
                                spreadRadius: 1, // Độ lan rộng của bóng
                                blurRadius: 4, // Độ mờ của bóng
                                offset:
                                    Offset(-1, 3), // Độ dịch chuyển của bóng
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Đặt lại',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
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
