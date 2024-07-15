import 'orders_manager.dart';
import 'order_item_card.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../products/favorite_products.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final ordersManager = Provider.of<OrdersManager>(context, listen: false);
    ordersManager.fetchOrders();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<OrdersManager>(
        builder: (ctx, ordersManager, child) {
          return ordersManager.orders.isEmpty
              ? const Center(
                  child: Text('No orders yet.'),
                )
              : ListView.builder(
                  itemCount: ordersManager.orderCount,
                  itemBuilder: (ctx, i) =>
                      OrderItemCard(ordersManager.orders[i]),
                );
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.grey,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //     switch (index) {
      //       case 0:
      //         Navigator.of(context).pushReplacementNamed('/');
      //         break;
      //       case 1:
      //         Navigator.of(context)
      //             .pushReplacementNamed(FavoriteScreen.routeName);
      //         break;
      //       case 2:
      //         Navigator.of(context)
      //             .pushReplacementNamed(OrdersScreen.routeName);
      //         break;
      //       case 3:
      //         context.read<AuthManager>().logout();
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.favorite),
      //       label: 'Favorites',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.payment),
      //       label: 'Order',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.exit_to_app),
      //       label: 'Log out',
      //     ),
      //   ],
      // ),
    );
  }
}
