class AddressModel {
  final String deliveryAddress;
  final String userName;
  final String phone;
  final String uid;

  AddressModel({
    required this.deliveryAddress,
    required this.userName,
    required this.phone,
    required this.uid,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      deliveryAddress: map['address'] ?? '',
      userName: map['name'] ?? '',
      phone: map['phone'] ?? '',
      uid: map['uid'] ?? '',
    );
  }
}
