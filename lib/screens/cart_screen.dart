import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<bool> selectedItems = [];
  bool selectAll = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cart = Provider.of<CartProvider>(context);

    if (selectedItems.length != cart.items.length) {
      selectedItems =
          List.generate(cart.items.length, (index) => false);
    }
  }

  double getTotalPrice(cart) {
    double total = 0;
    for (int i = 0; i < cart.items.length; i++) {
      if (selectedItems[i]) {
        total += cart.items[i].price *
            cart.items[i].quantity;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Giỏ hàng",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),

      body: cart.items.isEmpty
          ? const Center(child: Text("Giỏ hàng trống"))
          : Column(
        children: [
          /// LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: cart.items.length,
              itemBuilder: (_, i) {
                final item = cart.items[i];

                return Container(
                  margin:
                  const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black
                            .withOpacity(0.05),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      /// CHECKBOX
                      Checkbox(
                        value: selectedItems[i],
                        onChanged: (value) {
                          setState(() {
                            selectedItems[i] = value!;
                            selectAll = selectedItems
                                .every((e) => e);
                          });
                        },
                      ),

                      /// ẢNH
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(10),
                        child: Image.asset(
                          item.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                maxLines: 2,
                                overflow:
                                TextOverflow.ellipsis),

                            const SizedBox(height: 5),

                            Text(
                              "${item.price} đ",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            /// ➕➖ SỐ LƯỢNG
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                      Icons.remove),
                                  onPressed: () {
                                    cart.decrease(item);
                                  },
                                ),
                                Text(
                                    "${item.quantity}"),
                                IconButton(
                                  icon: const Icon(
                                      Icons.add),
                                  onPressed: () {
                                    cart.increase(item);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      /// 🗑️ DELETE
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red),
                        onPressed: () {
                          cart.remove(item);
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          /// FOOTER
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                  top:
                  BorderSide(color: Colors.black12)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Tổng tiền:"),
                    const Spacer(),
                    Text(
                      "${getTotalPrice(cart)} đ",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Checkbox(
                      value: selectAll,
                      onChanged: (value) {
                        setState(() {
                          selectAll = value!;
                          for (int i = 0;
                          i < selectedItems.length;
                          i++) {
                            selectedItems[i] = value;
                          }
                        });
                      },
                    ),
                    const Text("Tất cả"),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Mua"),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}