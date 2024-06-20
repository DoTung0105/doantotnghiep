class UserCart {
  final String name;
  double price;
  final String imagePath;
  final String description;
  final String brand;
  final String color;
  final String size;
  final String uid;
  int quantity;
  double evaluate;
  int sold;
  int wareHouse;

  UserCart({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.brand,
    required this.color,
    required this.size,
    required this.uid,
    this.quantity = 1,
    this.evaluate = 0.0,
    this.sold = 0,
    this.wareHouse = 0,
  });

  factory UserCart.fromMap(Map<String, dynamic> map) {
    return UserCart(
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imagePath: map['imagePath'] ?? '',
      description: map['description'] ?? '',
      brand: map['brand'] ?? '',
      color: map['color'] ?? '',
      size: map['size'] ?? '',
      uid: map['uid'] ?? '',
      quantity: map['quantity'] ?? 1,
      evaluate: map['evaluate']?.toDouble() ?? 0.0,
      sold: map['sold'] ?? 0,
      wareHouse: map['wareHouse'] ?? 0,
    );
  }
}
