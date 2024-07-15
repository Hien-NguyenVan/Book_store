import '../../models/cart_item.dart';
import 'package:flutter/foundation.dart';
import '../../services/cart_service.dart';
import '../../models/auth_token.dart';

class CartManager with ChangeNotifier {
  List<CartItem> _items = [];
  final CartService _cartService;

  CartManager([AuthToken? authToken]) : _cartService = CartService(authToken);

  set authToken(AuthToken? authToken) {
    _cartService.authToken = authToken;
  }

  int get productCount => _items.length;

  Future<List<CartItem>> fetchCartitem() async {
    _items = await _cartService.fetchCartItems();
    notifyListeners();
    return _items;
  }

  Future<void> addCartitem(CartItem cartitem) async {
    await _cartService.addCartItem(cartitem);
    notifyListeners();
  }

  Future<void> updateCartitem(CartItem cartItem) async {
    final index = _items.indexWhere((item) => item.id == cartItem.id);
    if (index >= 0) {
      if (await _cartService.updateCartItem(cartItem)) {
        _items[index] = cartItem;
        notifyListeners();
      }
    }
  }

  List<CartItem> get cartItems => _items.toList();

  Future<void> deleteCartitem(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    CartItem? existingProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _cartService.deleteCartItem(id)) {
      _items.insert(index, existingProduct);
      notifyListeners();
    }
  }

  Future<void> clearCartItems() async {
    await _cartService.clearCartItems();
    notifyListeners();
  }
}
