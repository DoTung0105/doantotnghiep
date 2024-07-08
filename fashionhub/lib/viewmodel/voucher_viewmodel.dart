import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionhub/model/voucher.dart';
import 'package:flutter/material.dart';

class VoucherViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'voucher';
  List<Voucher> vouchers = [];
  List<Voucher> get voucher => voucher;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Lấy danh sách voucher từ Firestore
  Future<void> fetchVouchers() async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await _db.collection(_collectionName).get();
      vouchers =
          querySnapshot.docs.map((doc) => Voucher.fromSnapshot(doc)).toList();
      await checkAndUpdateVoucherStatus();
    } catch (e) {
      print('Error fetching vouchers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// kiểm tra ngày hết hạn
  Future<void> checkAndUpdateVoucherStatus() async {
    DateTime now = DateTime.now();
    for (var voucher in vouchers) {
      if (voucher.expiry.toDate().isBefore(now)) {
        // If expired, set status to Inactive
        voucher.status = false;
        // Update status on Firestore
        _db.collection(_collectionName).doc(voucher.uid).update({
          'status': false,
        }).catchError((e) => print('Error updating voucher status: $e'));
      }
    }
    notifyListeners(); // Thông báo cho widget biết dữ liệu đã thay đổi
  }

  String generateRandomString() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        8, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  Future<void> addVoucher(String discount, Timestamp expiry,
      String quantityString // Nhận vào dưới dạng String
      ) async {
    try {
      // Chuyển đổi chuỗi thành số nguyên
      int quantity = int.parse(quantityString);

      String promotionalId = generateRandomString(); // Generate promotional_id
      DocumentReference docRef = await _db.collection(_collectionName).add({
        'promotional_id': promotionalId,
        'discount': discount,
        'expiry': expiry,
        'status': true,
        'quantity': quantity // Sử dụng biến đã chuyển đổi
      });

      // Tạo đối tượng voucher mới và thêm vào danh sách
      Voucher newVoucher = Voucher(
          uid: docRef.id,
          promotionalId: promotionalId,
          discount: discount,
          expiry: expiry,
          status: true,
          quantity: quantity // Sử dụng biến đã chuyển đổi
          );

      vouchers.add(newVoucher);
      notifyListeners();
    } catch (e) {
      print('Error adding voucher: $e');
    }
  }

  // Cập nhật trạng thái của voucher
  void updateVoucherStatus() {
    DateTime now = DateTime.now();
    for (var voucher in vouchers) {
      if (voucher.expiry.toDate().isBefore(now)) {
        // If expired, set status to Inactive
        voucher.status = false;
        // Update status on Firestore
        _db.collection(_collectionName).doc(voucher.uid).update({
          'status': false,
        }).catchError((e) => print('Error updating voucher status: $e'));
      }
    }
    notifyListeners();
  }

  Future<void> deleteVoucher(String uid) async {
    try {
      await _db.collection(_collectionName).doc(uid).delete();
      vouchers.removeWhere((voucher) => voucher.uid == uid);
      notifyListeners();
    } catch (e) {
      print('Error deleting voucher: $e');
      // In ra thông tin lỗi chi tiết
      if (e is FirebaseException) {
        print('Firestore Error code: ${e.code}');
        print('Firestore Error message: ${e.message}');
      }
    }
  }

  Future<void> updateVoucher(String uid, String discount, Timestamp expiry,
      String quantityString // Nhận vào dưới dạng String
      ) async {
    try {
      // Chuyển đổi chuỗi thành số nguyên
      int quantity = int.parse(quantityString);

      DocumentReference docRef = _db.collection(_collectionName).doc(uid);
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({
          'discount': discount,
          'expiry': expiry,
          'quantity': quantity,
        });

        // Cập nhật lại danh sách vouchers
        var index = vouchers.indexWhere((voucher) => voucher.uid == uid);
        if (index != -1) {
          vouchers[index].discount = discount;
          vouchers[index].expiry = expiry;
          vouchers[index].quantity = quantity;
          notifyListeners();
        }
      } else {
        print('Document with UID $uid does not exist.');
      }
    } catch (e) {
      print('Error updating voucher: $e');
    }
  }
}
