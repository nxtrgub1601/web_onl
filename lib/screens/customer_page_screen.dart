import 'package:flutter/material.dart';

class Customer {
  String name;
  String phone;
  String address;

  Customer({
    required this.name,
    required this.phone,
    required this.address,
  });
}

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final List<Customer> _allCustomers = [
    Customer(name: "Nguyễn Văn A", phone: "0901234567", address: "Hà Nội"),
    Customer(name: "Trần Thị B", phone: "0912345678", address: "TP HCM"),
    Customer(name: "Lê Văn C", phone: "0988888888", address: "Đà Nẵng"),
    Customer(name: "Phạm Thị D", phone: "0977777777", address: "Hải Phòng"),
  ];

  List<Customer> _filteredCustomers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCustomers = List.from(_allCustomers);
    _searchController.addListener(_filterCustomers);
  }

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredCustomers = List.from(_allCustomers);
      } else {
        _filteredCustomers = _allCustomers.where((c) {
          return c.name.toLowerCase().contains(query) ||
              c.phone.contains(query) ||
              c.address.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  // Thêm khách hàng mới
  void _showAddCustomerSheet() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Thêm khách hàng mới", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Họ và tên", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Số điện thoại", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: "Địa chỉ", border: OutlineInputBorder())),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
                    setState(() {
                      _allCustomers.add(Customer(
                        name: nameCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        address: addressCtrl.text.trim(),
                      ));
                      _filterCustomers();
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Thêm khách hàng"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Chỉnh sửa khách hàng
  void _showEditCustomerSheet(Customer customer, int index) {
    final nameCtrl = TextEditingController(text: customer.name);
    final phoneCtrl = TextEditingController(text: customer.phone);
    final addressCtrl = TextEditingController(text: customer.address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Chỉnh sửa khách hàng", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Họ và tên", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Số điện thoại", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: "Địa chỉ", border: OutlineInputBorder())),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _allCustomers.removeAt(index);
                        _filterCustomers();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Xóa", style: TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _allCustomers[index] = Customer(
                          name: nameCtrl.text.trim(),
                          phone: phoneCtrl.text.trim(),
                          address: addressCtrl.text.trim(),
                        );
                        _filterCustomers();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Lưu thay đổi"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý khách hàng", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm hiện đại
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchBar(
              controller: _searchController,
              hintText: "Tìm theo tên, SĐT hoặc địa chỉ...",
              leading: const Icon(Icons.search),
              trailing: _searchController.text.isNotEmpty
                  ? [IconButton(icon: const Icon(Icons.clear), onPressed: () => _searchController.clear())]
                  : null,
              elevation: const WidgetStatePropertyAll(1),
            ),
          ),

          // Danh sách khách hàng
          Expanded(
            child: _filteredCustomers.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text("Không tìm thấy khách hàng nào", style: TextStyle(fontSize: 16)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                final originalIndex = _allCustomers.indexOf(customer);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.person_rounded, size: 32, color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [const Icon(Icons.phone, size: 16), const SizedBox(width: 8), Text(customer.phone)]),
                          const SizedBox(height: 4),
                          Row(children: [const Icon(Icons.location_on, size: 16), const SizedBox(width: 8), Expanded(child: Text(customer.address, overflow: TextOverflow.ellipsis))]),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showEditCustomerSheet(customer, originalIndex),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Nút thêm khách hàng
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCustomerSheet,
        icon: const Icon(Icons.add),
        label: const Text("Thêm khách hàng"),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}