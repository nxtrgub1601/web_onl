import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../providers/cart_provider.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../data/product_data.dart';
import '../data/category_data.dart';
import '../widgets/product_item.dart';

import 'cart_screen.dart';
import 'person_screen.dart';
import 'product_page_screen.dart';
import 'layer_page_screen.dart';
import 'money_page_screen.dart';
import 'customer_page_screen.dart';
import 'order_page_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int selectedMenuIndex = -1;

  late List<Product> products;
  late List<Category> categories;

  List<Product> filteredProducts = [];
  List<Product> suggestions = [];

  final searchCtrl = TextEditingController();

  bool isSearching = false;
  bool showSuggestions = false;

  int selectedCategory = 0;

  Timer? _debounce;

  /// 🔥 BANNER
  int currentBanner = 0;

  final List<String> banners = [
    "assets/images/banner/banner1.jpg",
    "assets/images/banner/banner2.jpg",
    "assets/images/banner/banner3.jpg",
  ];

  @override
  void initState() {
    super.initState();
    products = ProductData.getProducts();
    categories = CategoryData.getCategories();
    filteredProducts = products;
  }

  /// 🔍 SEARCH (DEBOUNCE)
  void searchProduct(String keyword) {

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {

      setState(() {

        if (keyword.isEmpty) {
          isSearching = false;
          showSuggestions = false;
          applyFilter();
        } else {
          isSearching = true;
          showSuggestions = true;

          suggestions = products.where((p) {
            return p.name.toLowerCase().contains(keyword.toLowerCase());
          }).toList();

          filteredProducts = suggestions;
        }

      });

    });
  }

  /// FILTER CATEGORY
  void filterByCategory(int categoryId) {
    setState(() {
      selectedCategory = categoryId;
      searchCtrl.clear();
      isSearching = false;
      showSuggestions = false;
      applyFilter();
    });
  }

  /// APPLY FILTER
  void applyFilter() {
    if (selectedCategory == 0) {
      filteredProducts = products;
    } else {
      filteredProducts =
          products.where((p) => p.categoryId == selectedCategory).toList();
    }
  }

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [

          /// HEADER
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PersonScreen()));
                },
                child: const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              const Text("SHOP",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),

          const SizedBox(height: 15),

          /// 🔍 SEARCH + CART
          Column(
            children: [

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchCtrl,
                      onChanged: (value) => searchProduct(value),

                      decoration: InputDecoration(
                        hintText: "Tìm kiếm sản phẩm...",

                        prefixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => searchProduct(searchCtrl.text),
                        ),

                        suffixIcon: searchCtrl.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              searchCtrl.clear();
                              isSearching = false;
                              showSuggestions = false;
                              applyFilter();
                            });
                          },
                        )
                            : null,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// CART
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CartScreen()),
                          );
                        },
                      ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            cart.count.toString(),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),

              /// 🔥 GỢI Ý SEARCH
              if (showSuggestions) ...[
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5)
                    ],
                  ),
                  child: Column(
                    children: suggestions.take(5).map((p) {
                      return ListTile(
                        leading: Image.asset(p.image, width: 40),
                        title: Text(p.name),
                        onTap: () {
                          setState(() {
                            searchCtrl.text = p.name;
                            showSuggestions = false;
                            filteredProducts = [p];
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ]
            ],
          ),

          const SizedBox(height: 15),

          /// 🔥 BANNER XỊN
          Column(
            children: [

              CarouselSlider(
                options: CarouselOptions(
                  height: 150,
                  autoPlay: true,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentBanner = index;
                    });
                  },
                ),
                items: banners.map((img) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      img,
                      fit: BoxFit.contain, // 🔥 FIX KHÔNG CROP
                      width: double.infinity,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: banners.asMap().entries.map((entry) {
                  return Container(
                    width: currentBanner == entry.key ? 12 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentBanner == entry.key
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// MENU GIỮA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              menuIcon(Icons.store, "Sản phẩm", 0,
                      () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProductPage()))),

              menuIcon(Icons.assignment, "Đơn hàng", 2,
                      () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const OrderPage()))),

              menuIcon(Icons.attach_money, "Doanh thu", 3,
                      () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const MoneyPage()))),

              menuIcon(Icons.group, "Khách hàng", 4,
                      () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CustomerPage()))),
            ],
          ),

          const SizedBox(height: 15),

          /// CATEGORY
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final c = categories[i];
                final isSelected = selectedCategory == c.id;

                return GestureDetector(
                  onTap: () => filterByCategory(c.id),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          c.icon,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          c.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          /// PRODUCT GRID
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredProducts.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (_, i) {
              return ProductItem(product: filteredProducts[i]);
            },
          ),

          if (filteredProducts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text("Không tìm thấy sản phẩm")),
            ),
        ],
      ),
    );
  }

  Widget menuIcon(
      IconData icon,
      String text,
      int index,
      VoidCallback onTap,
      ) {
    bool isSelected = selectedMenuIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenuIndex = index;
        });
        onTap();
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}