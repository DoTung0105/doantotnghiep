class Clother {
  final String name;
  final String price;
  final String imagePath;
  final String description;
  final String brand;
  final String color;
  final String size;
  int quantity;
  double evaluate;
  int sold;
  int wareHouse;

  Clother({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.brand,
    required this.color,
    required this.size,
    this.quantity = 1,
    this.evaluate = 0.0,
    this.sold = 0,
    this.wareHouse = 0,
  });
}
