class UserModel {
  String uid;
  String email;
  String displayName;
  String address;
  String password; // Thêm trường password
  String phone;
  String role;
  bool? locked;
  String imagePath;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.address,
    required this.password,
    required this.phone,
    required this.role,
    this.locked = false,
    required this.imagePath,
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
      'locked': locked,
      'image': imagePath
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
        locked: map['locked'] ?? false,
        imagePath: map['image']
        // Thêm vào fromMap
        );
  }
}
