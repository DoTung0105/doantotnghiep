class Product {
  String id;
  String imagePath;
  String description;
  double price;

  String size;
  //them data
  String brand;
  String color;
  String name;
  int sold;

  int wareHouse;

  Product(
      {required this.id,
      required this.imagePath,
      required this.description,
      required this.price,
      required this.size,
      required this.brand,
      required this.color,
      required this.name,
      required this.sold,
      //them kho
      required this.wareHouse});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'description': description,
      'price': price,
      'size': size,
      'brand': brand,
      'color': color,
      'name': name,
      'sold': sold,
      'wareHouse': wareHouse
    };
  }

  // factory Product.fromMap(Map<String, dynamic> map) {
  //   return Product(
  //     id: map['id'],
  //     imageUrl: map['imageUrl'],
  //     description: map['description'],
  //     price: map['price'],
  //     size: map['size'],
  //   );
  // }
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'] ?? '',
        imagePath: map['imagePath'] ?? '',
        description: map['description'] ?? '',
        price: (map['price'] ?? 0).toDouble(),
        size: map['size'] ?? '',
        brand: map['brand'] ?? '',
        color: map['color'] ?? '',
        name: map['name'] ?? '',
        sold: map['sold'] ?? '',
        wareHouse: map['wareHouse'] ?? '');
  }
}
