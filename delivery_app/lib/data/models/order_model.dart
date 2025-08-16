import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String menuItemId; final String name; final num price; final int qty;
  const OrderItem({required this.menuItemId, required this.name, required this.price, required this.qty});
  Map<String, dynamic> toMap() => {'menuItemId': menuItemId, 'name': name, 'price': price, 'qty': qty};
  factory OrderItem.fromMap(Map<String, dynamic> m) => OrderItem(menuItemId: m['menuItemId'], name: m['name'], price: m['price'], qty: m['qty']);
  @override List<Object?> get props => [menuItemId, name, price, qty];
}

class Order extends Equatable {
  final String id, userId, restaurantId;
  final List<OrderItem> items;
  final num total;
  final String status; // |placed|accepted|rejected|preparing|ready_for_pickup|picked|delivered|
  final String? assignedRiderId;
  final DateTime createdAt;
  const Order({required this.id, required this.userId, required this.restaurantId, required this.items, required this.total, required this.status, this.assignedRiderId, required this.createdAt});
  factory Order.fromMap(String id, Map<String, dynamic> m) => Order(
      id: id, userId: m['userId'], restaurantId: m['restaurantId'],
      items: (m['items'] as List).map((e) => OrderItem.fromMap(e)).toList(),
      total: m['total'], status: m['status'], assignedRiderId: m['assignedRiderId'],
      createdAt: (m['createdAt'] as Timestamp).toDate());
  Map<String, dynamic> toMap() => {
    'userId': userId, 'restaurantId': restaurantId,
    'items': items.map((e) => e.toMap()).toList(),
    'total': total, 'status': status, 'assignedRiderId': assignedRiderId, 'createdAt': createdAt
  };
  @override List<Object?> get props => [id, userId, restaurantId, items, total, status, assignedRiderId, createdAt];
}