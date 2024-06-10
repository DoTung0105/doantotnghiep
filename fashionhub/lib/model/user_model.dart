class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String address;
  final String password; // Thêm trường password
  final String phone;
  final String role;
  bool? locked;

  UserModel(
      {required this.uid,
      required this.email,
      required this.displayName,
      required this.address,
      required this.password,
      required this.phone,
      required this.role,
      this.locked = false

      // Thêm vào constructor
      });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'address': address,
      'password': password,
      'phone': phone,
      'role': role,
      'locked': locked
      // Thêm vào map
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        displayName: map['displayName'],
        address: map['address'],
        password: map['password'],
        phone: map['phone'],
        role: map['role'],
        locked: map['locked'] ?? false
        // Thêm vào fromMap
        );
  }
}
