import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/view/list_voucher.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class DeliveryTimeComponent extends StatefulWidget {
  final double storeLatitude;
  final double storeLongitude;
  final String customerAddress;
  final Function(String, String) onFeeUpdated;
  final double totalPayment;

  const DeliveryTimeComponent({
    Key? key,
    required this.storeLatitude,
    required this.storeLongitude,
    required this.customerAddress,
    required this.onFeeUpdated,
    required this.totalPayment,
  }) : super(key: key);

  @override
  _DeliveryTimeComponentState createState() => _DeliveryTimeComponentState();
}

class _DeliveryTimeComponentState extends State<DeliveryTimeComponent> {
  Position? _userPosition;
  String _deliveryTime = 'Đang tính toán...';
  String _distance = 'Đang tính toán...';
  TextEditingController _discountController = TextEditingController();
  String? _discountedFee;
  double _standardFee = 0.0; // Giá trị phí vận chuyển tiêu chuẩn
  final NumberFormat _currencyFormat =
      NumberFormat('#,##0', 'vi_VN'); // Sử dụng NumberFormat
  String? _errorMessage; // Biến để lưu thông báo lỗi mã giảm giá
  bool _isDiscountApplied = false; // Biến để theo dõi việc áp dụng mã giảm giá

  @override
  void initState() {
    super.initState();
    _calculateDistanceAndTime();
  }

  // Phương thức để tính toán khoảng cách và thời gian giao hàng
  Future<void> _calculateDistanceAndTime() async {
    try {
      await convertAddressToCoordinates(widget.customerAddress);

      List<Location> locations =
          await locationFromAddress(widget.customerAddress);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        double customerLatitude = location.latitude;
        double customerLongitude = location.longitude;

        double distanceInMeters = await Geolocator.distanceBetween(
          widget.storeLatitude,
          widget.storeLongitude,
          customerLatitude,
          customerLongitude,
        );

        String estimatedTimeRange =
            _estimateDeliveryTimeRange(distanceInMeters);
        double distanceInKm = distanceInMeters / 1000; // Đổi sang km
        String distanceInKmString = distanceInKm.toStringAsFixed(
            1); // Chuyển đổi sang chuỗi và làm tròn đến 1 chữ số thập phân

        setState(() {
          _deliveryTime = estimatedTimeRange;
          _distance = '$distanceInKmString km';
        });

        _standardFee =
            _calculateStandardFee(distanceInKm); // Lưu giá trị phí tiêu chuẩn
        widget.onFeeUpdated('${_currencyFormat.format(_standardFee)}đ', '0đ');
      } else {
        setState(() {
          _deliveryTime = 'Không thể tính toán thời gian';
          _distance = 'Không thể tính toán khoảng cách';
        });
      }
    } catch (e) {
      print("Error calculating distance and time: $e");
      setState(() {
        _deliveryTime = 'Không thể tính toán thời gian';
        _distance = 'Không thể tính toán khoảng cách';
      });
    }
  }

  // Phương thức ước tính thời gian giao hàng dựa trên khoảng cách
  String _estimateDeliveryTimeRange(double distanceInMeters) {
    double distanceInKm = distanceInMeters / 1000;

    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    if (distanceInKm >= 0 && distanceInKm < 70) {
      startDate = now.add(Duration(days: 1));
      endDate = now.add(Duration(days: 3));
    } else if (distanceInKm >= 70 && distanceInKm <= 2000) {
      startDate = now.add(Duration(days: 7));
      endDate = now.add(Duration(days: 9));
    } else {
      return 'Khoảng cách không hợp lệ hoặc quá xa.';
    }

    String startDateFormat = DateFormat('MMM dd').format(startDate);
    String endDateFormat = DateFormat('MMM dd').format(endDate);

    return '$startDateFormat - $endDateFormat';
  }

  // Phương thức tính phí vận chuyển tiêu chuẩn dựa trên khoảng cách
  double _calculateStandardFee(double distanceInKm) {
    if (distanceInKm <= 50) {
      return 15700;
    } else {
      return 35000;
    }
  }

  // Phương thức tính phí vận chuyển đã giảm
  String transportFee() {
    double feeValue = _discountedFee != null
        ? double.parse(_discountedFee!.replaceAll('đ', '').replaceAll('.', ''))
        : _standardFee;

    return '${_currencyFormat.format(feeValue)}đ';
  }

  // Phương thức áp dụng mã giảm giá
  Future<void> _applyDiscount(String discountCode) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('voucher')
          .where('promotional_id', isEqualTo: discountCode)
          .where('status', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final voucher = querySnapshot.docs.first;
        double discountPercentage = double.parse(voucher['discount']) / 100.0;

        if (_standardFee > 0) {
          double discountedValue = _standardFee * (1 - discountPercentage);
          String discountedFee = '${_currencyFormat.format(discountedValue)}đ';
          String discountAmount =
              '${_currencyFormat.format(_standardFee - discountedValue)}đ'; // Tính toán số tiền được giảm

          // Giảm số lượng mã giảm giá trên Firestore
          int currentQuantity = voucher['quantity'];
          if (currentQuantity > 0) {
            await FirebaseFirestore.instance
                .collection('voucher')
                .doc(voucher.id)
                .update({'quantity': currentQuantity - 1});
          } else {
            setState(() {
              _errorMessage = 'Mã đã hết lượt sử dụng';
            });
            return;
          }

          setState(() {
            _discountedFee = discountedFee;
            _errorMessage = null; // Xóa thông báo lỗi nếu có
            _isDiscountApplied = true; // Đánh dấu mã giảm giá đã được áp dụng
          });

          widget.onFeeUpdated(discountedFee, discountAmount);
        }
      } else {
        setState(() {
          _errorMessage = 'Mã không hợp lệ hoặc đã được sử dụng';
        });
      }
    } catch (e) {
      print('Error applying discount: $e');
      setState(() {
        _errorMessage = 'Mã không hợp lệ hoặc đã được sử dụng';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String fee = transportFee();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isDiscountApplied)
          Text(
            'Đã áp dụng voucher giảm phí vận chuyển',
            style: TextStyle(color: Colors.blue),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Vận chuyển tiêu chuẩn:',
              style: TextStyle(color: Colors.grey),
            ),
            Text('${_currencyFormat.format(_standardFee)}đ'),
          ],
        ),
        Text('Từ Q1 - Tp.HCM', style: TextStyle(color: Colors.grey)),
        Text(
          'Ngày giao hàng dự kiến: $_deliveryTime',
          style: TextStyle(color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 38.0,
                  child: TextField(
                    controller: _discountController,
                    enabled:
                        !_isDiscountApplied, // Disable TextField if discount is applied
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: 'Nhập mã giảm giá',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                height: 38.0,
                child: ElevatedButton(
                  onPressed: () {
                    // Xử lý việc áp dụng mã giảm giá
                    String discountCode = _discountController.text;
                    _applyDiscount(discountCode);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Màu nền
                    foregroundColor: Colors.white, // Màu chữ
                    elevation: 0, // Không có bóng
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  child: Text('Áp dụng'),
                ),
              ),
            ],
          ),
        ),
        if (_errorMessage != null) // Hiển thị thông báo lỗi nếu có
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListVoucher(
                    totalPayment: widget
                        .totalPayment), // Truyền totalPayment vào ListVoucher
              ),
            ),
            child: Row(
              children: [
                Image.asset('lib/images/voucher_code.png'),
                const SizedBox(width: 10),
                Text(
                  'Thu thập mã giảm giá',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Hàm chuyển đổi địa chỉ thành tọa độ
Future<void> convertAddressToCoordinates(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      Location location = locations.first;
      double latitude = location.latitude;
      double longitude = location.longitude;
      print('Latitude: $latitude, Longitude: $longitude');
    } else {
      print('Không tìm thấy vị trí cho địa chỉ.');
    }
  } catch (e) {
    print('Lỗi khi chuyển đổi địa chỉ thành tọa độ: $e');
  }
}
