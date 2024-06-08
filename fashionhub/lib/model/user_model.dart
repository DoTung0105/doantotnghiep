class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String address;
  final String password; // Thêm trường password
  final String phone;


  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.address,
    required this.password,
    required this.phone,
   
     // Thêm vào constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'address': address,
      'password': password,
      'phone':phone,
     
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
      phone:map['phone'],
      
       // Thêm vào fromMap
    );
  }
}
