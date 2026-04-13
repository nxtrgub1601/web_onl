import '../models/product.dart';

class ProductData {
  static List<Product> getProducts() {
    return [

      /// 👕 ÁO
      Product(id: 1, name: "Áo phông basic", image: "assets/images/ao.png", price: 250000, categoryId: 1),
      Product(id: 2, name: "Áo phông form rộng", image: "assets/images/ao.png", price: 320000, categoryId: 1),
      Product(id: 3, name: "Áo hoodie", image: "assets/images/ao_khoac.png", price: 650000, categoryId: 1),
      Product(id: 4, name: "Áo khoác dù", image: "assets/images/ao_khoac.png", price: 890000, categoryId: 1),
      Product(id: 5, name: "Áo sơ mi trắng", image: "assets/images/ao.png", price: 400000, categoryId: 1),

      /// 👖 QUẦN
      Product(id: 6, name: "Quần jean xanh", image: "assets/images/quan.png", price: 780000, categoryId: 2),
      Product(id: 7, name: "Quần jean đen", image: "assets/images/quan.png", price: 820000, categoryId: 2),
      Product(id: 8, name: "Quần short", image: "assets/images/quan.png", price: 300000, categoryId: 2),
      Product(id: 9, name: "Quần jogger", image: "assets/images/quan.png", price: 550000, categoryId: 2),
      Product(id: 10, name: "Quần kaki", image: "assets/images/quan.png", price: 600000, categoryId: 2),

      /// 🧢 PHỤ KIỆN
      Product(id: 11, name: "Mũ lưỡi trai", image: "assets/images/mu.png", price: 150000, categoryId: 3),
      Product(id: 12, name: "Mũ bucket", image: "assets/images/mu.png", price: 200000, categoryId: 3),
      Product(id: 13, name: "Cặp sách thời trang", image: "assets/images/bag.png", price: 900000, categoryId: 3),
      Product(id: 14, name: "Ba lô laptop", image: "assets/images/bag.png", price: 1200000, categoryId: 3),
      Product(id: 15, name: "Túi đeo chéo", image: "assets/images/bag.png", price: 450000, categoryId: 3),

      /// 🔥 HOT / RANDOM
      Product(id: 16, name: "Áo thun graphic", image: "assets/images/ao.png", price: 350000, categoryId: 1),
      Product(id: 17, name: "Quần thể thao", image: "assets/images/quan.png", price: 500000, categoryId: 2),
      Product(id: 18, name: "Mũ snapback", image: "assets/images/mu.png", price: 220000, categoryId: 3),
      Product(id: 19, name: "Áo khoác bomber", image: "assets/images/ao_khoac.png", price: 1100000, categoryId: 1),
      Product(id: 20, name: "Quần baggy", image: "assets/images/quan.png", price: 670000, categoryId: 2),
    ];
  }
}