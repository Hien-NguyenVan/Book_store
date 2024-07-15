import '../../models/cart_item.dart';
import '../../models/order_item.dart';
import 'package:flutter/foundation.dart';
import '../../services/orders_service.dart';
import 'package:ct484_project/models/auth_token.dart';

class OrdersManager with ChangeNotifier {
  final OrdersService _ordersService;
  List<OrderItem> _items = [];

  OrdersManager([AuthToken? authToken])
      : _ordersService = OrdersService(authToken);

  set authToken(AuthToken? authToken) {
    _ordersService.authToken = authToken;
  }

  int get orderCount {
    return _items.length;
  }

  List<OrderItem> get orders {
    return [..._items];
  }

  Future<List<OrderItem>> fetchOrders() async {
    _items = await _ordersService.fetchOrders();
    notifyListeners();
    return _items;
  }

  Future<void> addOrder(OrderItem orderItem) async {
    await _ordersService.addOrder(orderItem);
    notifyListeners();
  }
}
