import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryData {
  static List<Category> getCategories() {
    return [
      Category(id: 0, name: "Tất cả", icon: Icons.apps),
      Category(id: 1, name: "Áo", icon: Icons.checkroom),
      Category(id: 2, name: "Quần", icon: Icons.shopping_bag),
      Category(id: 3, name: "Phụ kiện", icon: Icons.watch),
    ];
  }
}