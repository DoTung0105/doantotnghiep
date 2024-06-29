import 'package:fashionhub/components/delivery_time.dart';
import 'package:fashionhub/components/layout_widget.dart';
import 'package:fashionhub/model/address_model.dart';
import 'package:fashionhub/model/userCart_model.dart';
import 'package:fashionhub/view/map_sample.dart';
import 'package:fashionhub/viewmodel/cart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CheckOutPage extends StatefulWidget {
  final List<UserCart> selectedItems;

  const CheckOutPage({super.key, required this.selectedItems});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  bool isChecked = false;
  String? name;
  String? phone;
  String? address;
  LatLng? pickedLocation;
  String fee = 'Đang tính toán...';

  @override
  void initState() {
    super.initState();
    fetchUserAddress(); // Gọi hàm lấy địa chỉ người dùng khi khởi tạo
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
                    onFeeUpdated: (updatedFee) {
                      setState(() {
                        fee = updatedFee;
                      });
                    },
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
                          Text('Tổng đơn hàng'),
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
                      Text('-25.000đ', style: TextStyle(color: Colors.red)),
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
                          Text(
                            'Liên kết',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            size: 30,
                          ),
                          SizedBox(width: 18),
                          Text(
                            'Thẻ tín dụng/Thẻ ghi nợ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                      'Tổng',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    PriceWidget(price: totalOrderAmount),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Bạn đã tiết kiệm được 41.000đ',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý đặt hàng
                    },
                    child: Text('Đặt hàng'),
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
