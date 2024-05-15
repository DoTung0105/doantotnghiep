class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String address;

  UserModel(
      {required this.uid, required this.email, required this.displayName,required this.address});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'address': address,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      address:  map['address']
    );
  }
}
