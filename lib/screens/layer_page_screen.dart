import 'package:flutter/material.dart';

class LayerPage extends StatelessWidget {
  const LayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh mục")),
      body: const Center(child: Text("Layer Page")),
    );
  }
}