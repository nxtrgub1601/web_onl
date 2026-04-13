class Product {
  final int id;
  final String name;
  final String image;
  final double price;
  final int categoryId;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.categoryId,
    this.quantity = 1,
  });
}