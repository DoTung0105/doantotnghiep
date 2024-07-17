import 'package:cloud_firestore/cloud_firestore.dart';
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
  String selectedStatus = 'Tất cả';
  String searchOrderId = '';
  String searchPhoneNumber = '';
  DateTime? searchDate;

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
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(children: [
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.48,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Nhập mã đơn hàng...',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {}); // Force rebuild to apply filter
                            },
                            icon: Icon(Icons.search),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchOrderId = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedStatus,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(
                                30), // Điều chỉnh border radius
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                        dropdownColor: Colors.white,
                        icon: Icon(Icons.arrow_drop_down), // Thêm icon dropdown
                        iconSize: 30, // Điều chỉnh kích thước icon dropdown
                        elevation: 5, // Điều chỉnh độ nổi của dropdown
                        style: TextStyle(color: Colors.black),
                        items: [
                          'Tất cả',
                          'Chờ xác nhận',
                          'Đang giao',
                          'Thành công',
                          'Đã hủy',
                        ].map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(
                                status,
                                style: TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.48, // Điều chỉnh chiều rộng
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Nhập số điện thoại...',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {}); // Force rebuild to apply filter
                            },
                            icon: Icon(Icons.search),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchPhoneNumber = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.44,
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'Chọn ngày...',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          searchDate = pickedDate;
                                        });
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        searchDate = null;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            controller: TextEditingController(
                              text: searchDate != null
                                  ? DateFormat('dd/MM/yyyy').format(searchDate!)
                                  : '',
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ]),
            ),
            Expanded(
              child: Consumer<User_Order_ViewModel>(
                builder: (context, orderViewModel, child) {
                  if (orderViewModel.orders.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Lọc danh sách đơn hàng dựa trên trạng thái và orderId được chọn/nhập
                  List<User_Order> filteredOrders =
                      orderViewModel.orders.where((order) {
                    bool matchesStatus = selectedStatus == 'Tất cả' ||
                        order.status == selectedStatus;
                    bool matchesOrderId = searchOrderId.isEmpty ||
                        order.orderId
                            .toLowerCase()
                            .contains(searchOrderId.toLowerCase());
                    bool matchesPhoneNumber = searchPhoneNumber.isEmpty ||
                        order.phone
                            .toLowerCase()
                            .contains(searchPhoneNumber.toLowerCase());
                    bool matchesDate = searchDate == null ||
                        DateFormat('dd/MM/yyyy')
                                .format(order.orderday.toDate()) ==
                            DateFormat('dd/MM/yyyy').format(searchDate!);
                    return matchesStatus &&
                        matchesOrderId &&
                        matchesPhoneNumber &&
                        matchesDate;
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      User_Order order = filteredOrders[index];
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
                              tilePadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
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
                                  user != null
                                      ? user.displayName
                                      : 'Unknown User',
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
                                ListTile(
                                  title: Text(
                                      'Phương thức thanh toán: ${order.paymentMethods}'),
                                ),
                                ...order.products.map((product) {
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                title: Text(
                                                    'Màu: ${product.color}'),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                    'Size: ${product.size}'),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                Divider(thickness: 1),
                                order.status == 'Thành công'
                                    ? Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          'Đơn hàng đã hoàn thành',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            order.status == 'Đang giao'
                                                ? ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12,
                                                              horizontal: 24),
                                                    ),
                                                    onPressed: () async {
                                                      // Cập nhật trạng thái đơn hàng thành 'Thành công'
                                                      await orderViewModel
                                                          .updateOrderStatus(
                                                              order.orderId,
                                                              'Thành công');

                                                      // Cập nhật số lượng kho và số lượng bán ra của từng sản phẩm
                                                      for (var item
                                                          in order.products) {
                                                        QuerySnapshot
                                                            productSnapshot =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'products')
                                                                .where('name',
                                                                    isEqualTo: item
                                                                        .productName)
                                                                .where('color',
                                                                    isEqualTo: item
                                                                        .color)
                                                                .where('size',
                                                                    isEqualTo:
                                                                        item.size)
                                                                .get();

                                                        for (var doc
                                                            in productSnapshot
                                                                .docs) {
                                                          var productData =
                                                              doc.data() as Map<
                                                                  String,
                                                                  dynamic>;
                                                          int currentSold =
                                                              productData[
                                                                      'sold'] ??
                                                                  1;
                                                          int currentWareHouse =
                                                              productData[
                                                                      'wareHouse'] ??
                                                                  1;

                                                          int newSold =
                                                              currentSold +
                                                                  item.quantity;
                                                          int newWareHouse =
                                                              currentWareHouse -
                                                                  item.quantity;

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'products')
                                                              .doc(doc.id)
                                                              .update({
                                                            'sold': newSold,
                                                            'wareHouse':
                                                                newWareHouse,
                                                          });
                                                        }
                                                      }

                                                      setState(
                                                          () {}); // Cập nhật giao diện
                                                    },
                                                    child: Text('Thành công',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white)),
                                                  )
                                                : ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12,
                                                              horizontal: 24),
                                                    ),
                                                    onPressed: () async {
                                                      await orderViewModel
                                                          .updateOrderStatus(
                                                              order.orderId,
                                                              'Đang giao');
                                                      setState(() {});
                                                    },
                                                    child: Text('Duyệt',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                backgroundColor: Colors.red,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 24),
                                              ),
                                              onPressed: () async {
                                                await orderViewModel
                                                    .updateOrderStatus(
                                                        order.orderId,
                                                        'Đã hủy');
                                                setState(
                                                    () {}); // Cập nhật giao diện
                                              },
                                              child: Text('Từ chối',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      ),
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
          ],
        ),
      ),
    );
  }
}
