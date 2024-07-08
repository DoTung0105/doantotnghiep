import 'package:fashionhub/model/user_model.dart';
import 'package:fashionhub/model/userorder.dart';
import 'package:fashionhub/viewmodel/user_order_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Orders_Screen extends StatefulWidget {
  @override
  State<Orders_Screen> createState() => _Orders_ScreenState();
}

class _Orders_ScreenState extends State<Orders_Screen> {
  late User_Order_ViewModel orderViewModel;

  @override
  void initState() {
    super.initState();
    orderViewModel = User_Order_ViewModel();
    orderViewModel.fetchOrders().then((_) {
      setState(() {}); // Cập nhật giao diện sau khi fetch dữ liệu
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => orderViewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Danh sách đơn hàng'),
        ),
        body: Consumer<User_Order_ViewModel>(
          builder: (context, orderViewModel, child) {
            if (orderViewModel.orders.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: orderViewModel.orders.length,
              itemBuilder: (context, index) {
                User_Order order = orderViewModel.orders[index];
                UserModel? user = orderViewModel.getUserById(order.uid);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    child: ExpansionTile(
                      title: ListTile(
                        leading: user != null && user.imagePath.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(user.imagePath),
                              )
                            : CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                        title: Text(
                            user != null ? user.displayName : 'Unknown User'),
                        subtitle: Text('Trạng thái đơn hàng: ${order.status}'),
                      ),
                      children: [
                        ListTile(
                          title: Text(
                              'Địa chỉ nhận hàng: ${order.deliveryAddress}'),
                        ),
                        ListTile(
                          title: Text('Người nhận: ${order.userName}'),
                        ),
                        Divider(thickness: 1),
                        ListTile(
                          title: Text('Điện thoại: ${order.phone}'),
                        ),
                        Divider(thickness: 1),
                        ...order.products
                            .map((product) => Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                          'Tên sản phẩm: ${product.productName}'),
                                    ),
                                    Divider(thickness: 1),
                                    ListTile(
                                      title: Text('Màu: ${product.color}'),
                                    ),
                                    Divider(thickness: 1),
                                    ListTile(
                                      title: Text('Size: ${product.size}'),
                                    ),
                                    Divider(thickness: 1),
                                    ListTile(
                                      title: Text(
                                          'Số lượng: x${product.quantity}'),
                                    ),
                                    Divider(thickness: 1),
                                    ListTile(
                                      title: Text(
                                          'Giá: ${NumberFormat('#,###').format(product.price)}đ'),
                                    ),
                                    Divider(thickness: 1),
                                  ],
                                ))
                            .toList(),
                        ListTile(
                          title: Text(
                              'Phí vận chuyển: ${NumberFormat('#,###').format(order.fee)}'),
                        ),
                        Divider(thickness: 1),
                        ListTile(
                            title: Text(
                          'Tổng đơn hàng: ${order.totalPrice}',
                        )),
                        Divider(thickness: 1),
                        ListTile(
                          title: Text(
                              'Thời gian đặt hàng: ${DateFormat('dd/MM/yyyy').format(order.orderday.toDate())}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                ),
                                onPressed: () async {
                                  await orderViewModel.updateOrderStatus(
                                      order.orderId, 'Đang giao');
                                  setState(() {}); // Cập nhật giao diện
                                },
                                child: Text('Duyệt',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black)),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await orderViewModel.updateOrderStatus(
                                      order.orderId, 'Hủy đơn');
                                  setState(() {}); // Cập nhật giao diện
                                },
                                child: Text(
                                  'Từ chối',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
