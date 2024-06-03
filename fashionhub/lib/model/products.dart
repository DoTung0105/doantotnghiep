class Product {
  String id;
  String imageUrl;
  String description;
  double price;
  String size;

  Product({required this.id, required this.imageUrl, required this.description, required this.price, required this.size});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'description': description,
      'price': price,
      'size': size,
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
  );
}

}
