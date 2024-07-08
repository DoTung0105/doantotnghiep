import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/components/delivery_time.dart';
import 'package:fashionhub/components/layout_widget.dart';
import 'package:fashionhub/components/momo_payment.dart';
import 'package:fashionhub/model/address_model.dart';
import 'package:fashionhub/model/order_model.dart';
import 'package:fashionhub/model/userCart_model.dart';
import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/home_page.dart';
import 'package:fashionhub/view/map_sample.dart';
import 'package:fashionhub/viewmodel/cart_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CheckOutPage extends StatefulWidget {
  final List<UserCart> selectedItems;
  final double totalPayment;

  const CheckOutPage(
      {super.key, required this.selectedItems, required this.totalPayment});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  bool isChecked = false;
  String? name;
  String? phone;
  String? address;
  LatLng? pickedLocation;
  String fee = '0đ';
  String discountAmount = '0đ';
  double _deliveryFee = 0.0;
  final NumberFormat _currencyFormat = NumberFormat('#,##0', 'vi_VN');
  final AuthenticationService _authenticationService =
      AuthenticationService(); // Khởi tạo đối tượng AuthenticationServi
  String? currentUserId;
  @override
  void initState() {
    super.initState();
    fetchUserAddress(); // Gọi hàm lấy địa chỉ người dùng khi khởi tạo
    getCurrentUserId();
  }

  // Hàm lấy địa chỉ người dùng từ Provider
  Future<void> fetchUserAddress() async {
    AddressModel? userAddress =
        await Provider.of<Cart>(context, listen: false).fetchUserAddress();
    if (userAddress != null) {
      setState(() {
        name = userAddress.userName;
        phone = userAddress.phone;
        address = userAddress.deliveryAddress;
      });
    }
  }

  void getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  // Hàm che số điện thoại
  String maskPhoneNumber(String phone) {
    if (phone.length < 4)
      return phone; // Đảm bảo số điện thoại có ít nhất 4 chữ số
    return '${phone.substring(1, 3)}*****${phone.substring(phone.length - 2)}';
  }

  // Hàm tính tổng số tiền của đơn hàng
  double calculateTotalOrderAmount() {
    double total = 0.0;
    for (var item in widget.selectedItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Hàm tính tổng tiền thanh toán bao gồm phí vận chuyển
  double calculateTotalPayment() {
    double totalOrderAmount = calculateTotalOrderAmount();
    return totalOrderAmount + _deliveryFee;
  }

  Future<void> placeOrder() async {
    // Chuẩn bị dữ liệu đơn hàng từ widget và các biến khác
    String status = 'Chờ xác nhận';
    String paymentMethod =
        isChecked ? 'Thanh toán khi nhận hàng' : 'Đã thanh toán';

    // Lấy uid của người dùng hiện tại
    User? currentUser = _authenticationService.getCurrentUser();
    if (currentUser == null) {
      print('User is not logged in');
      return;
    }
    String uid = currentUser.uid;

    // Tạo danh sách các sản phẩm trong đơn hàng
    List<OrderProduct> products = widget.selectedItems
        .map((item) => OrderProduct(
              imagePath: item.imagePath,
              productName: item.productName,
              color: item.color,
              size: item.size,
              quantity: item.quantity,
              price: item.price,
            ))
        .toList();

    // Tính tổng tiền của đơn hàng
    double totalPayment = calculateTotalPayment();
    String formattedTotalPrice = _currencyFormat.format(totalPayment) + 'đ';

    // Tạo một DocumentReference mới cho đơn hàng
    DocumentReference newOrderRef =
        FirebaseFirestore.instance.collection('userOrders').doc();

    // Tạo đối tượng Order_class từ các thông tin hiện tại
    Order_class order = Order_class(
      orderId: newOrderRef.id,
      userName: name ?? '',
      phone: phone ?? '',
      deliveryAddress: address ?? '',
      products: products,
      totalPrice: formattedTotalPrice,
      fee: _deliveryFee,
      status: status,
      uid: uid,
      paymentMethods: paymentMethod,
      orderday: Timestamp.now(),
    );

    try {
      // Lưu đơn hàng vào Firestore
      await newOrderRef.set(order.toMap());

      // Xóa sản phẩm đã thanh toán khỏi giỏ hàng
      Provider.of<Cart>(context, listen: false)
          .removeItems(widget.selectedItems);

      // Hiển thị thông báo hoặc chuyển hướng sau khi lưu thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: IntrinsicHeight(
              child: AlertDialog(
                titlePadding: EdgeInsets.all(10),
                contentPadding: EdgeInsets.all(10),
                actionsPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        // Điều hướng trở lại HomePage và xóa ngăn xếp điều hướng
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Sau khi đặt hàng thành công, có thể làm sạch giỏ hàng hoặc thực hiện các hành động khác
    } catch (e) {
      // Xử lý lỗi nếu có
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Đặt hàng thất bại. Vui lòng thử lại sau.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print('Error placing order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gom các sản phẩm theo thương hiệu
    Map<String, List<UserCart>> itemsByBrand = {};
    for (var item in widget.selectedItems) {
      if (itemsByBrand.containsKey(item.brand)) {
        itemsByBrand[item.brand]!.add(item);
      } else {
        itemsByBrand[item.brand] = [item];
      }
    }

    double totalOrderAmount = calculateTotalOrderAmount();
    double totalPayment = calculateTotalPayment();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Đặt hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, bottom: 2),
            width: MediaQuery.of(context).size.width - 5,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_sharp,
                      size: 18,
                    ),
                    SizedBox(width: 3),
                    Text(
                      name ?? "Thêm địa chỉ nhận hàng",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (phone != null) ...[
                      SizedBox(width: 5),
                      Text(
                        '(+84)${maskPhoneNumber(phone!)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                    Spacer(flex: 1),
                    IconButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapSample(
                              onLocationPicked: (LatLng newLocation) {
                                print(newLocation);
                              },
                              initialName: name,
                              initialPhone: phone,
                              initialAddress: address,
                            ),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            name = result['name'];
                            phone = result['phone'];
                            address = result['location'];
                            pickedLocation = result['pickedLocation'];
                          });
                        }
                      },
                      icon: Icon(Icons.edit, size: 15),
                    ),
                  ],
                ),
                if (address != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      address!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...itemsByBrand.entries.map((entry) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 200, 194, 194),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          ...entry.value.map((item) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      color: Colors.grey[200],
                                      child: Image.network(
                                        item.imagePath,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productName,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(height: 6),
                                          Row(
                                            children: [
                                              PriceWidget(
                                                price: item.price / 0.6,
                                                style: TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(width: 25),
                                              Text(
                                                '${item.color}, ${item.size}',
                                                style: TextStyle(
                                                    color: Colors.grey[800]),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              PriceWidget(
                                                price: item.price,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 25),
                                                child: Text(
                                                  'x${item.quantity}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }).toList(),
                  Divider(),
                  DeliveryTimeComponent(
                    storeLatitude: 10.771936,
                    storeLongitude: 106.701369,
                    customerAddress: address ?? 'Thêm địa chỉ nhận hàng',
                    onFeeUpdated: (updatedFee, discountAmountValue) {
                      setState(() {
                        fee = updatedFee;
                        _deliveryFee = double.parse(updatedFee
                            .replaceAll('đ', '')
                            .replaceAll(
                                '.', '')); // Cập nhật giá trị chiết khấu
                        discountAmount = discountAmountValue;
                      });
                    },
                    totalPayment:
                        totalPayment, // Truyền totalPayment vào DeliveryTimeComponent
                  ),
                  Divider(),
                  Text(
                    'Tóm tắt yêu cầu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng sản phẩm'),
                          PriceWidgetII(price: totalOrderAmount),
                        ],
                      ),
                      ...widget.selectedItems
                          .map((item) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${item.productName}',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        Text(
                                          'x${item.quantity}',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        PriceWidgetII(
                                          price: item.price * item.quantity,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Vận chuyển'),
                          Text(fee),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Chiết khấu phí vận chuyển'),
                      Text(discountAmount, style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  Divider(),
                  Text(
                    'Phương thức thanh toán',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset('lib/images/cod.png', width: 30),
                      SizedBox(width: 18),
                      Text(
                        'Thanh toán khi nhận hàng',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isChecked
                                ? Border.all(color: Colors.red)
                                : Border.all(color: Colors.grey),
                            color: isChecked ? Colors.red : Colors.transparent,
                          ),
                          child: isChecked
                              ? Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Image.asset('lib/images/momo.png', width: 30),
                          SizedBox(width: 8),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ví điện tử MoMo',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Liên kết tài khoản Ví điện tử MoMo\ncủa bạn để thanh toán trực tiếp.',
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MomoPaymentPage(),
                                )),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Phần này tính tổng của các sản phẩm đã chọn
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 3),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    PriceWidget(price: totalPayment),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isChecked) {
                        // Hiển thị thông báo lỗi nếu phương thức thanh toán chưa được chọn
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Vui lòng chọn phương thức thanh toán'),
                            backgroundColor: Colors.grey[800],
                          ),
                        );
                        return;
                      }
                      // Xử lý đặt hàng
                      placeOrder();
                    },
                    child: Text('Đặt hàng ngay'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
