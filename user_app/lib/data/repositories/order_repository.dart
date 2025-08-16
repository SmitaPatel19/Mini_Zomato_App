import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order.dart';

class OrderRepository {
  final _db = FirebaseFirestore.instance;

  Future<String> placeOrder(Order order) async {
    final ref = _db.collection('orders').doc();
    await ref.set(order.toMap()..['createdAt'] = FieldValue.serverTimestamp());
    return ref.id;
  }

  Stream<List<Order>> userOrders(String userId) => _db
      .collection('orders')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map((d) => Order.fromMap(d.id, d.data())).toList());

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
        ],
      )
      .snapshots()
      .map((s) => s.docs.map((d) => Order.fromMap(d.id, d.data())).toList());

  Stream<List<Order>> riderOrders(String riderId) => _db
      .collection('orders')
      .where('assignedRiderId', isEqualTo: riderId)
      .snapshots()
      .map((s) => s.docs.map((d) => Order.fromMap(d.id, d.data())).toList());

  Future<void> updateStatus(String orderId, String status, {String? riderId}) =>
      _db.collection('orders').doc(orderId).update({
        'status': status,
        if (riderId != null) 'assignedRiderId': riderId,
      });
}
