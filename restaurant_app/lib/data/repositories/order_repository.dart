import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order_model.dart';

class OrderRepository {
  final _db = FirebaseFirestore.instance;

  // Place a new order
  Future<String> placeOrder(Order order) async {
    final ref = _db.collection('orders').doc();
    await ref.set(order.toMap()..['createdAt'] = FieldValue.serverTimestamp());
    return ref.id;
  }

  // Stream of incoming orders for a restaurant
  Stream<List<Order>> incomingOrders(String restaurantId) {
    return _db
        .collection('orders')
        .where('restaurantId', isEqualTo: restaurantId)
        .where('status', isEqualTo: 'incoming')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Order.fromMap(d.id, d.data())).toList(),
        );
  }

  // Stream of orders for a user
  Stream<List<Order>> userOrders(String userId) => _db
      .collection('orders')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map((d) => Order.fromMap(d.id, d.data())).toList());

  // Stream of all restaurant incoming orders with multiple statuses
  Stream<List<Order>> restaurantIncoming(String rid) => _db
      .collection('orders')
      .where('restaurantId', isEqualTo: rid)
      .where(
        'status',
        whereIn: [
          'pending',
          'placed',
          'accepted',
          'preparing',
          'ready_for_pickup',
          'picked',
          'delivered',
        ],
      )
      .snapshots()
      .map((s) => s.docs.map((d) => Order.fromMap(d.id, d.data())).toList());

  // Stream of orders assigned to a rider
  Stream<List<Order>> riderOrders(String riderId) => _db
      .collection('orders')
      .where('assignedRiderId', isEqualTo: riderId)
      .snapshots()
      .map((s) => s.docs.map((d) => Order.fromMap(d.id, d.data())).toList());

  // Update order status (optionally assign rider)
  Future<void> updateStatus(String orderId, String status, {String? riderId}) =>
      _db.collection('orders').doc(orderId).update({
        'status': status,
        if (riderId != null) 'assignedRiderId': riderId,
      });

  // ------------------- NEW METHODS -------------------

  /// Fetch a single order by its ID
  Future<Order> getOrderById(String orderId) async {
    final doc = await _db.collection('orders').doc(orderId).get();
    if (!doc.exists) throw Exception('Order not found');
    return Order.fromMap(doc.id, doc.data()!);
  }

  /// Stream of orders for a specific restaurant
  Stream<List<Order>> streamOrdersByRestaurant(String restaurantId) {
    return _db
        .collection('orders')
        .where('restaurantId', isEqualTo: restaurantId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Order.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}
