import 'package:cloud_firestore/cloud_firestore.dart';

class OrderProduct {
  final String imagePath;
  final String productName;
  final String color;
  final String size;
  final int quantity;
  final double price;

  OrderProduct({
    required this.imagePath,
    required this.productName,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'productName': productName,
      'color': color,
      'size': size,
      'quantity': quantity,
      'price': price,
    };
  }
}

class Order_class {
  final String orderId;
  String userName;
  String phone;
  String deliveryAddress;
  List<OrderProduct> products; // Danh sách các sản phẩm trong đơn hàng
  String totalPrice;
  double fee;
  String status;
  final String uid;
  String paymentMethods;
  final Timestamp orderday;

  Order_class({
    required this.orderId,
    required this.userName,
    required this.phone,
    required this.deliveryAddress,
    required this.products,
    required this.totalPrice,
    required this.fee,
    required this.status,
    required this.uid,
    required this.paymentMethods,
    required this.orderday,
  });

  // Factory constructor to create Order from a map (Firestore document)
  factory Order_class.fromMap(Map<String, dynamic> map) {
    List<dynamic> productsMap = map['products'] ?? [];
    List<OrderProduct> products = productsMap
        .map((product) => OrderProduct(
              imagePath: product['imagePath'] ?? '',
              productName: product['productName'] ?? '',
              color: product['color'] ?? '',
              size: product['size'] ?? '',
              quantity: product['quantity'] ?? 0,
              price: product['price']?.toDouble() ?? 0.0,
            ))
        .toList();

    return Order_class(
      orderId: map['orderId'] ?? '',
      userName: map['userName'] ?? '',
      phone: map['phone'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',
      products: products,
      totalPrice: map['totalPrice'] ?? '',
      fee: map['fee']?.toDouble() ?? 0.0,
      status: map['status'] ?? 'Chờ xác nhận',
      uid: map['uid'] ?? '',
      paymentMethods: map['paymentMethods'] ?? 'Thanh toán khi nhận hàng',
      orderday: map['orderday'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> productsMap =
        products.map((product) => product.toMap()).toList();

    return {
      'orderId': orderId,
      'userName': userName,
      'phone': phone,
      'deliveryAddress': deliveryAddress,
      'products': productsMap,
      'totalPrice': totalPrice,
      'fee': fee,
      'status': status,
      'uid': uid,
      'paymentMethods': paymentMethods,
      'orderday': orderday,
    };
  }
}
