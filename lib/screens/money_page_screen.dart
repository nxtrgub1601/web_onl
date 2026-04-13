import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyPage extends StatefulWidget {
  const MoneyPage({super.key});

  @override
  State<MoneyPage> createState() => _MoneyPageState();
}

class _MoneyPageState extends State<MoneyPage> {
  DateTimeRange selectedRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 6)),
    end: DateTime.now(),
  );

  String selectedPeriod = "Tuần"; // Ngày, Tuần, Tháng, Năm

  // Demo data
  int totalOrders = 128;
  int totalRevenue = 87500000;
  double avgOrderValue = 683593;
  double growthRate = 12.5; // % so với kỳ trước

  final List<Map<String, dynamic>> recentOrders = [
    {"id": "#ORD-8921", "time": "Hôm nay 14:32", "amount": 1250000, "status": "Hoàn thành"},
    {"id": "#ORD-8920", "time": "Hôm nay 11:15", "amount": 890000, "status": "Hoàn thành"},
    {"id": "#ORD-8919", "time": "Hôm qua 19:45", "amount": 2450000, "status": "Hoàn thành"},
    {"id": "#ORD-8918", "time": "Hôm qua 09:20", "amount": 670000, "status": "Hoàn thành"},
  ];

  // Demo data cho biểu đồ (doanh thu theo ngày trong tuần)
  final List<double> chartData = [4.2, 6.8, 5.1, 9.3, 12.7, 8.4, 15.2]; // triệu đồng

  Future<void> pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.blue),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedRange = picked;
        // Ở đây bạn có thể reload data từ API theo range mới
      });
    }
  }

  void changePeriod(String period) {
    setState(() {
      selectedPeriod = period;
      // Thay đổi range tương ứng (demo)
      final now = DateTime.now();
      if (period == "Ngày") {
        selectedRange = DateTimeRange(start: now, end: now);
      } else if (period == "Tuần") {
        selectedRange = DateTimeRange(
          start: now.subtract(const Duration(days: 6)),
          end: now,
        );
      } else if (period == "Tháng") {
        selectedRange = DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: now,
        );
      } else if (period == "Năm") {
        selectedRange = DateTimeRange(
          start: DateTime(now.year, 1, 1),
          end: now,
        );
      }
    });
  }

  String formatDateRange(DateTimeRange range) {
    final formatter = DateFormat('dd/MM/yyyy');
    if (range.start == range.end) {
      return formatter.format(range.start);
    }
    return "${formatter.format(range.start)} - ${formatter.format(range.end)}";
  }

  String formatMoney(int money) {
    return "${money.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')} đ";
  }

  String formatCompactMoney(int money) {
    if (money >= 1000000000) {
      return "${(money / 1000000000).toStringAsFixed(1)} Tỷ";
    } else if (money >= 1000000) {
      return "${(money / 1000000).toStringAsFixed(1)} Tr";
    }
    return formatMoney(money);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Doanh thu", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chọn khoảng thời gian
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          formatDateRange(selectedRange),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_calendar),
                        onPressed: pickDateRange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Filter nhanh
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ["Ngày", "Tuần", "Tháng", "Năm"].map((p) {
                        final isSelected = selectedPeriod == p;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(p),
                            selected: isSelected,
                            onSelected: (_) => changePeriod(p),
                            backgroundColor: Colors.grey[100],
                            selectedColor: Colors.blue.shade100,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.blue : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Thống kê chính
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Tổng đơn",
                    totalOrders.toString(),
                    Icons.shopping_cart_outlined,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    "Doanh thu",
                    formatCompactMoney(totalRevenue),
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Giá trị TB/đơn",
                    formatMoney(avgOrderValue.toInt()),
                    Icons.analytics,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    "Tăng trưởng",
                    "+${growthRate.toStringAsFixed(1)}%",
                    Icons.trending_up,
                    Colors.teal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Biểu đồ doanh thu
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Doanh thu theo ngày",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 18,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
                                if (value.toInt() >= 0 && value.toInt() < days.length) {
                                  return Text(days[value.toInt()], style: const TextStyle(fontSize: 12));
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: chartData.asMap().entries.map((e) {
                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value,
                                color: Colors.blue.shade400,
                                width: 22,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Danh sách đơn hàng gần đây
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Đơn hàng gần đây",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full order list
                  },
                  child: const Text("Xem tất cả"),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ...recentOrders.map((order) => _buildOrderItem(order)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order["id"], style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(order["time"], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatMoney(order["amount"]),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order["status"],
                  style: TextStyle(color: Colors.green.shade700, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}