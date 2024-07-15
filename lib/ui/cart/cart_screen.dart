import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ct484_project/ui/cart/cart_manager.dart';
import 'package:ct484_project/models/cart_item.dart';
import '../orders/orders_manager.dart';
import '../../models/order_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> _fetchCartItems;

  @override
  void initState() {
    super.initState();
    _fetchCartItems = context.read<CartManager>().fetchCartitem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<CartManager>(
        builder: (context, cartManager, child) {
          final cartItems = cartManager.cartItems;

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              return ListTile(
                leading: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.network(cartItem.imageUrl),
                ),
                title: Text(
                  cartItem.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Số lượng: ${cartItem.quantity}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${cartItem.price * cartItem.quantity}đ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        cartManager.deleteCartitem(cartItem.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartManager>(
        builder: (context, cartManager, child) {
          final cartItems = cartManager.cartItems;
          final totalPrice = cartItems.fold(
              0.0,
              (previousValue, cartItem) =>
                  previousValue + cartItem.price * cartItem.quantity);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Tổng giá tiền: $totalPriceđ',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    final ordersManager = context.read<OrdersManager>();
                    final orderItem = OrderItem(
                      amount: totalPrice,
                      cartItems: cartItems,
                    );
                    ordersManager.addOrder(orderItem);
                    cartManager.clearCartItems();
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.yellowAccent,
                  ),
                  child: const Text(
                    'BUY',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
