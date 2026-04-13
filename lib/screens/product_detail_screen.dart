import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// 🔝 APPBAR
      appBar: AppBar(
        title: Text(product.name),
        centerTitle: true,
        elevation: 0,
      ),

      /// 📱 BODY
      body: Column(
        children: [
          /// 🖼 ẢNH SẢN PHẨM
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Image.asset(
              product.image,
              fit: BoxFit.cover,
            ),
          ),

          /// 📦 THÔNG TIN
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🏷 TÊN
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 💰 GIÁ
                  Row(
                    children: [
                      Text(
                        "${product.price} đ",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "299.000đ",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// ⭐ ĐÁNH GIÁ
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.orange, size: 18),
                      Icon(Icons.star, color: Colors.orange, size: 18),
                      Icon(Icons.star, color: Colors.orange, size: 18),
                      Icon(Icons.star, color: Colors.orange, size: 18),
                      Icon(Icons.star_half, color: Colors.orange, size: 18),
                      SizedBox(width: 5),
                      Text("4.5 (120 đánh giá)"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 📝 MÔ TẢ
                  const Text(
                    "Mô tả sản phẩm",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Sản phẩm chất lượng cao, thiết kế đẹp, phù hợp với mọi nhu cầu sử dụng. "
                        "Bảo hành 12 tháng, đổi trả trong 7 ngày.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      /// 🔻 BUTTON DƯỚI
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          children: [
            /// ❤️ FAVORITE
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border, color: Colors.red),
            ),

            /// 🛒 ADD TO CART
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  cart.add(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text("Đã thêm ${product.name} vào giỏ"),
                          ),
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text(
                  "Thêm vào giỏ hàng",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}