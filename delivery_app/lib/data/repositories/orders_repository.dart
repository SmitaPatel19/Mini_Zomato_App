import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order_model.dart';

class OrderRepository {
  final _db = FirebaseFirestore.instance;

  // Stream of incoming orders for a restaurant
  Stream<List<Order>> incomingOrders(String deliveryId) {
    return _db
        .collection('orders')
        .where('assignedRiderId', isEqualTo: deliveryId)
        .where('status', isEqualTo: 'ready_for_pickup')
        .snapshots()
        .map((snap) => snap.docs.map((d) => Order.fromMap(d.id, d.data())).toList());
  }

  // Stream of orders assigned to a rider
  Stream<List<Order>> riderOrders(String riderId) => _db
      .collection('orders')
      .where('assignedRiderId', isEqualTo: riderId)
      .where('status', whereIn: ['delivered', 'picked', 'ready_for_pickup'])
      .snapshots()
      .map((s) => s.docs.map((d) => Order.fromMap(d.id, d.data())).toList());

  // Update order status (optionally assign rider)
  Future<void> updateStatus(String orderId, String status, {String? riderId}) =>
      _db.collection('orders').doc(orderId).update({'status': status, if (riderId != null) 'assignedRiderId': riderId});

  /// Fetch a single order by its ID
  Future<Order> getOrderById(String orderId) async {
    final doc = await _db.collection('orders').doc(orderId).get();
    if (!doc.exists) throw Exception('Order not found');
    return Order.fromMap(doc.id, doc.data()!);
  }

}
