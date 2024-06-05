class Product {
  String id;
  String imageUrl;
  String description;
  double price;
  String size;
  //them data
  String branch;
  String color;
  String name;
  String sold;

  String warehouse;

  Product(
      {required this.id,
      required this.imageUrl,
      required this.description,
      required this.price,
      required this.size,
      required this.branch,
      required this.color,
      required this.name,
      required this.sold,
      //them kho
      required this.warehouse});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'description': description,
      'price': price,
      'size': size,
      'branch': branch,
      'color': color,
      'name': name,
      'sold': sold,
      'warehouse':warehouse
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
        imageUrl: map['imageUrl'] ?? '',
        description: map['description'] ?? '',
        price: (map['price'] ?? 0).toDouble(),
        size: map['size'] ?? '',
        branch: map['branch'] ?? '',
        color: map['color'] ?? '',
        name: map['name'] ?? '',
        sold: map['sold'] ?? '',
        warehouse: map['warehouse']);
  }
}
