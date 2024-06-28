import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {
  String uid;
  String promotionalId; // Thay đổi tên thành id
  String discount;
  Timestamp expiry;
  bool status;
  String quanlity;

  Voucher(
      {required this.uid,
      required this.promotionalId,
      required this.discount,
      required this.expiry,
      required this.status,
      required this.quanlity});

  factory Voucher.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Voucher(
        uid: snapshot.id,
        promotionalId: data['promotional_id'],
        discount: data['discount'],
        expiry: data['expiry'],
        status: data['status'],
        quanlity: data['quanlity']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'promotional_id': promotionalId,
      'discount': discount,
      'expiry': expiry,
      'status': status,
      'quanlity': quanlity
    };
  }
}
