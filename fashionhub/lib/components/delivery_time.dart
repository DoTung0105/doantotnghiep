import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class DeliveryTimeComponent extends StatefulWidget {
  final double storeLatitude;
  final double storeLongitude;
  final String customerAddress;
  final Function(String) onFeeUpdated;

  const DeliveryTimeComponent({
    Key? key,
    required this.storeLatitude,
    required this.storeLongitude,
    required this.customerAddress,
    required this.onFeeUpdated,
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
        widget.onFeeUpdated('${_currencyFormat.format(_standardFee)}đ');
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
  void _applyDiscount(String discountCode, double discountPercentage) {
    if (_standardFee > 0) {
      double discountedValue = _standardFee * (1 - discountPercentage);
      String discountedFee = '${_currencyFormat.format(discountedValue)}đ';

      setState(() {
        _discountedFee = discountedFee;
      });

      widget.onFeeUpdated(discountedFee);
    }
  }

  @override
  Widget build(BuildContext context) {
    String fee = transportFee();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    double discountPercentage =
                        0.2; // Thay đổi phần trăm giảm giá tại đây
                    _applyDiscount(discountCode, discountPercentage);
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
