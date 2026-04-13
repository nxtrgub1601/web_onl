import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  /// ➕ Thêm sản phẩm (không bị trùng)
  void add(Product product) {
    final index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(product);
    }

    notifyListeners();
  }

  /// ❌ Xóa sản phẩm
  void remove(Product product) {
    _items.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  /// ➕ Tăng số lượng
  void increase(Product product) {
    final index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  /// ➖ Giảm số lượng
  void decrease(Product product) {
    final index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index); // nếu =1 thì xóa luôn
      }
      notifyListeners();
    }
  }

  /// 🔢 Số lượng sản phẩm (tính cả quantity)
  int get count {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// 💰 Tổng tiền (có quantity)
  double get totalPrice {
    return _items.fold(
      0,
          (sum, item) => sum + (item.price * item.quantity),
    );
  }

  /// 🧹 Xóa toàn bộ giỏ hàng
  void clear() {
    _items.clear();
    notifyListeners();
  }
}