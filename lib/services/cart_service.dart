import 'dart:convert';
import 'firebase_service.dart';
import '../models/cart_item.dart';
import '../models/auth_token.dart';

class CartService extends FirebaseService {
  CartService([AuthToken? authToken]) : super(authToken);

  Future<List<CartItem>> fetchCartItems() async {
    final List<CartItem> cartitem = [];
    try {
      final cartItemsMap =
          await httpFetch('$databaseUrl/cart/$userId.json?auth=$token')
              as Map<String, dynamic>?;

      cartItemsMap?.forEach((cartItemId, cartItem) {
        cartitem.add(
          CartItem.fromJson({
            'id': cartItemId,
            ...cartItem,
          }),
        );
      });

      return cartitem;
    } catch (error) {
      print(error);
      return cartitem;
    }
  }

  Future<void> addCartItem(CartItem cartItem) async {
    try {
      await httpFetch(
        '$databaseUrl/cart/$userId/${cartItem.id}.json?auth=$token',
        method: HttpMethod.put,
        body: jsonEncode(
          cartItem.toJson(),
        ),
      ) as Map<String, dynamic>?;
    } catch (error) {
      print(error);
    }
  }

  Future<bool> updateCartItem(CartItem cartItem) async {
    try {
      await httpFetch(
        '$databaseUrl/cart/$userId/${cartItem.id}.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(cartItem.toJson()),
      );
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deleteCartItem(String cartItemId) async {
    try {
      await httpFetch(
        '$databaseUrl/cart/$userId/$cartItemId.json?auth=$token',
        method: HttpMethod.delete,
      );
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> clearCartItems() async {
    try {
      await httpFetch('$databaseUrl/cart/$userId.json?auth=$token',
          method: HttpMethod.delete);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
