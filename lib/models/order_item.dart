import 'cart_item.dart';

class OrderItem {
  final String? id;
  final double amount;
  final List<CartItem> cartItems;
  final DateTime dateTime;

  int get productCount {
    return cartItems.length;
  }

  OrderItem({
    this.id,
    required this.amount,
    required this.cartItems,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  OrderItem copyWith({
    String? id,
    double? amount,
    List<CartItem>? cartItems,
    DateTime? dateTime,
  }) {
    return OrderItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      cartItems: cartItems ?? this.cartItems,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'cartItems': cartItems.map((cartItems) => cartItems.toJson()).toList(),
      'dateTime': dateTime.toIso8601String(),
    };
  }

  static OrderItem fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      amount: json['amount'],
      cartItems: (json['cartItems'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
