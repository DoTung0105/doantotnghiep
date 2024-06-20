class Clother {
  final String name;
  final double price;
  final String imagePath;
  final String description;
  final String brand;
  final String color;
  final String size;
  final double evaluate;
  final int sold;
  final int wareHouse;
  final int quantity;

  Clother({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.brand,
    required this.color,
    required this.size,
    required this.evaluate,
    required this.sold,
    required this.wareHouse,
    this.quantity = 1,
  });
}
