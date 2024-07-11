import 'package:fashionhub/animation/animation.dart';
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
  Set<String> approvedOrders = Set<String>();

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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: FadeAnimation(
                    0.1,
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
                        title: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundImage:
                                user != null && user.imagePath.isNotEmpty
                                    ? NetworkImage(user.imagePath)
                                    : AssetImage('lib/images/user.png')
                                        as ImageProvider,
                          ),
                          title: Text(
                            user != null ? user.displayName : 'Unknown User',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Trạng thái đơn hàng: ${order.status}',
                          ),
                        ),
                        children: [
                          Divider(thickness: 1),
                          ListTile(
                            title: Text(
                                'Địa chỉ nhận hàng: ${order.deliveryAddress}'),
                          ),
                          ListTile(
                            title: Text('Người nhận: ${order.userName}'),
                          ),
                          ListTile(
                            title: Text('Điện thoại: ${order.phone}'),
                          ),
                          ListTile(
                            title: Text(
                                'Thời gian đặt hàng: ${DateFormat('dd/MM/yyyy').format(order.orderday.toDate())}'),
                          ),
                          ...order.products.map((product) {
                            return Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Sản phẩm: ${product.productName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text('Màu: ${product.color}'),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text('Size: ${product.size}'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                              'Giá: ${NumberFormat('#,###').format(product.price)}đ'),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                              'Số lượng: ${product.quantity}'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          Divider(thickness: 1),
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ngày giao hàng dự kiến: ${order.deliveryTime}',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  'Phí vận chuyển: ${NumberFormat('#,###').format(order.fee)}đ',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              'Tổng đơn hàng: ${order.totalPrice}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Divider(thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              approvedOrders.contains(order.orderId)
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.green,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 24),
                                      ),
                                      onPressed: () async {
                                        await orderViewModel.updateOrderStatus(
                                            order.orderId, 'Thành công');
                                        setState(() {}); // Cập nhật giao diện
                                      },
                                      child: Text('Thành công',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white)),
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.green,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 24),
                                      ),
                                      onPressed: () async {
                                        await orderViewModel.updateOrderStatus(
                                            order.orderId, 'Đang giao');
                                        setState(() {
                                          approvedOrders.add(order.orderId);
                                        }); // Cập nhật giao diện
                                      },
                                      child: Text('Duyệt',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white)),
                                    ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24),
                                ),
                                onPressed: () async {
                                  await orderViewModel.updateOrderStatus(
                                      order.orderId, 'Đã hủy');
                                  setState(() {}); // Cập nhật giao diện
                                },
                                child: Text('Từ chối',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
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
