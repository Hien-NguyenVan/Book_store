import 'package:flutter/material.dart';

import '../../ui/products/products_manager.dart';

import 'package:provider/provider.dart';
import 'products_grid.dart';

class FindProductsScreen extends StatefulWidget {
  static const routeName = '/find-product';
  const FindProductsScreen({super.key});

  @override
  State<FindProductsScreen> createState() => _FindProductScreenState();
}

class _FindProductScreenState extends State<FindProductsScreen> {
  late Future<void> _fetchProducts;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _fetchProducts =
        context.read<ProductsManager>().fetchProductswithfind(title: '');
  }

  void _searchProducts() {
    String searchTerm = _searchController.text;

    _fetchProducts = context
        .read<ProductsManager>()
        .fetchProductswithfind(title: searchTerm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45, left: 20),
              child: SizedBox(
                width: 330,
                height: 45,
                child: TextField(
                  autofocus: true,
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Nhập từ khóa tìm kiếm',
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    filled: false,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  onSubmitted: (String searchTerm) {
                    _searchProducts();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _fetchProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const ProductsGrid(false, 4);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
