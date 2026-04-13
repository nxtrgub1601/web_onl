import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';   // ← Đã thêm lại để dùng nút Đăng xuất

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  String name = "Nguyễn Văn A";
  String gender = "Nam";
  String birth = "01/01/2000";
  String phone = "0123456789";
  String email = "example@gmail.com";

  final List<Map<String, dynamic>> _infoList = [];

  @override
  void initState() {
    super.initState();
    _updateInfoList();
  }

  void _updateInfoList() {
    _infoList.clear();
    _infoList.addAll([
      {'title': 'Họ và tên', 'value': name, 'icon': Icons.person},
      {'title': 'Giới tính', 'value': gender, 'icon': Icons.wc},
      {'title': 'Ngày sinh', 'value': birth, 'icon': Icons.cake},
      {'title': 'Số điện thoại', 'value': phone, 'icon': Icons.phone},
      {'title': 'Email', 'value': email, 'icon': Icons.email},
    ]);
  }

  void _showEditDialog() {
    final nameCtrl = TextEditingController(text: name);
    final genderCtrl = TextEditingController(text: gender);
    final birthCtrl = TextEditingController(text: birth);
    final phoneCtrl = TextEditingController(text: phone);
    final emailCtrl = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Chỉnh sửa hồ sơ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameCtrl, "Họ và tên", Icons.person),
              const SizedBox(height: 12),
              _buildTextField(genderCtrl, "Giới tính", Icons.wc),
              const SizedBox(height: 12),
              _buildTextField(birthCtrl, "Ngày sinh", Icons.cake),
              const SizedBox(height: 12),
              _buildTextField(phoneCtrl, "Số điện thoại", Icons.phone),
              const SizedBox(height: 12),
              _buildTextField(emailCtrl, "Email", Icons.email),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {
                name = nameCtrl.text.trim();
                gender = genderCtrl.text.trim();
                birth = birthCtrl.text.trim();
                phone = phoneCtrl.text.trim();
                email = emailCtrl.text.trim();
                _updateInfoList();
              });
              Navigator.pop(context);
            },
            child: const Text("Lưu thay đổi"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Hồ sơ cá nhân"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage("assets/images/hinh_nen.jpg"),
                  backgroundColor: Colors.grey,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Tính năng cập nhật ảnh đang phát triển")),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // Thông tin cá nhân
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: _infoList.map((item) => ListTile(
                    leading: Icon(item['icon'] as IconData, color: Colors.blueGrey),
                    title: Text(
                      item['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      item['value'] as String,
                      style: const TextStyle(fontSize: 16),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                  )).toList(),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ==================== NÚT ĐĂNG XUẤT ====================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Đăng xuất",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // Nút chỉnh sửa (FloatingActionButton)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showEditDialog,
        icon: const Icon(Icons.edit),
        label: const Text("Chỉnh sửa"),
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
      ),
    );
  }
}