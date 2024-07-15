import './products_grid.dart';
import 'top_right_badge.dart';
import '../cart/cart_screen.dart';

import '../cart/cart_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ct484_project/ui/products/products_manager.dart';
import '../../ui/products/find_products.dart';
import '../auth/auth_manager.dart';

import '../orders/orders_screen.dart';

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  int _currentIndex = 0;
  final _typeNotifier = ValueNotifier<int>(4);
  late Future<void> _fetchProducts;
  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: const Text(
            'FASHION STORE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pushNamed(FindProductsScreen.routeName);
              },
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(OrdersScreen.routeName);
                },
                icon: const Icon(Icons.payment)),
            ShoppingCartButton(
              onPressed: () {
                // Chuyển đến trang CartScreen
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(0.1),
            child: Divider(
              color: Colors.grey,
              indent: 20.0,
              endIndent: 20.0,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
            child: Image.network(
                'https://marketplace.canva.com/EAFOnfV1H8s/1/0/1600w/canva-blue-fashionman-sale-banner-mVk9lxekuFk.jpg'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    // borderRadius:
                    //     BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _typeNotifier.value = (_typeNotifier.value == 0) ? 4 : 0;
                    },
                    child: const Text(
                      "SHIRT",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    // borderRadius:
                    //     BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _typeNotifier.value = (_typeNotifier.value == 1) ? 4 : 1;
                      print(_typeNotifier);
                    },
                    child: const Text(
                      "PANTS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    // borderRadius:
                    //     BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _typeNotifier.value = (_typeNotifier.value == 2) ? 4 : 2;
                      print(_typeNotifier);
                    },
                    child: const Text(
                      "SHOE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    // borderRadius:
                    //     BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _typeNotifier.value = (_typeNotifier.value == 3) ? 4 : 3;
                    },
                    child: const Text(
                      "WATCH",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _fetchProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ValueListenableBuilder(
                    valueListenable: _typeNotifier,
                    builder: (context, type, child) {
                      return ProductsGrid(_showOnlyFavorites.value, type);
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              _showOnlyFavorites.value = false;
              _typeNotifier.value = 4;
              _currentIndex = 0;
              break;
            case 1:
              _showOnlyFavorites.value = true;
              _typeNotifier.value = 4;
              _currentIndex = 1;
              break;
            case 2:
              context.read<AuthManager>().logout();
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Log out',
          ),
        ],
      ),
    );
  }
}

class ShoppingCartButton extends StatelessWidget {
  const ShoppingCartButton({super.key, this.onPressed});

  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    // Truy xuất CartManager thông qua widget Consumer
    return Consumer<CartManager>(
      builder: (ctx, cartManager, child) {
        // Bao IconButton với TopRightBadge
        return TopRightBadge(
          data: cartManager.productCount,
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
            onPressed: onPressed,
          ),
        );
      },
    );
  }
}
