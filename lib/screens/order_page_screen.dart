import 'package:flutter/material.dart';

// ==================== MODEL ====================
class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class Order {
  final String id;
  final String date;
  final double total;
  final String status;
  final String customerName;
  final String phone;
  final String address;
  final List<OrderItem> items;
  final double shippingFee;
  final double discount;

  Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.items,
    this.shippingFee = 30000,
    this.discount = 0,
  });
}

// ==================== ORDER PAGE ====================
class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Order> orders = [
      Order(
        id: "HD001",
        date: "01/04/2026",
        total: 1350000,
        status: "Đã giao",
        customerName: "Nguyễn Văn A",
        phone: "0123456789",
        address: "Số 12, Ngõ 45, Đường Cầu Giấy, Hà Nội",
        items: [
          OrderItem(name: "Áo thun nam basic", quantity: 2, price: 250000),
          OrderItem(name: "Quần jeans slim fit", quantity: 1, price: 650000),
          OrderItem(name: "Mũ lưỡi trai", quantity: 1, price: 150000),
        ],
      ),
      Order(
        id: "HD002",
        date: "02/04/2026",
        total: 880000,
        status: "Đang xử lý",
        customerName: "Nguyễn Văn A",
        phone: "0123456789",
        address: "Số 12, Ngõ 45, Đường Cầu Giấy, Hà Nội",
        items: [
          OrderItem(name: "Giày thể thao nam", quantity: 1, price: 850000),
        ],
        discount: 50000,
      ),
      Order(
        id: "HD003",
        date: "05/04/2026",
        total: 450000,
        status: "Đã hủy",
        customerName: "Nguyễn Văn A",
        phone: "0123456789",
        address: "Số 12, Ngõ 45, Đường Cầu Giấy, Hà Nội",
        items: [
          OrderItem(name: "Áo sơ mi trắng", quantity: 1, price: 480000),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Đơn hàng của tôi"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];

          Color statusColor = order.status == "Đã giao"
              ? Colors.green
              : order.status == "Đang xử lý"
              ? Colors.orange
              : Colors.red;

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Đơn hàng #${order.id}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text("Ngày đặt: ${order.date}"),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tổng tiền:", style: TextStyle(fontSize: 16)),
                      Text(
                        "${order.total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} đ",
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailPage(order: order),
                          ),
                        );
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text("Xem chi tiết"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==================== ORDER DETAIL PAGE ====================
class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    Color statusColor = order.status == "Đã giao"
        ? Colors.green
        : order.status == "Đang xử lý"
        ? Colors.orange
        : Colors.red;

    double subtotal = order.items.fold(0, (sum, item) => sum + item.price * item.quantity);

    return Scaffold(
      appBar: AppBar(
        title: Text("Đơn hàng #${order.id}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trạng thái
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Thông tin người nhận
            const Text("Thông tin người nhận", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Người nhận: ${order.customerName}", style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("Số điện thoại: ${order.phone}"),
                    const SizedBox(height: 8),
                    Text("Địa chỉ: ${order.address}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Danh sách sản phẩm
            const Text("Sản phẩm", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text("Số lượng: ${item.quantity}"),
                    trailing: Text(
                      "${(item.price * item.quantity).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} đ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Thông tin thanh toán
            const Text("Thông tin thanh toán", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPaymentRow("Tạm tính", subtotal),
                    if (order.discount > 0)
                      _buildPaymentRow("Giảm giá", -order.discount, isDiscount: true),
                    _buildPaymentRow("Phí vận chuyển", order.shippingFee),
                    const Divider(),
                    _buildPaymentRow(
                      "Tổng thanh toán",
                      order.total,
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, double amount, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 17 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            "${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} đ",
            style: TextStyle(
              fontSize: isTotal ? 19 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isDiscount ? Colors.green : (isTotal ? Colors.blueGrey : null),
            ),
          ),
        ],
      ),
    );
  }
}