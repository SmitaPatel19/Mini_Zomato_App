// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class RestaurantRepository {
//   final _db = FirebaseFirestore.instance;
//   CollectionReference get _restaurants => _db.collection('restaurents');
//
//   /// Get all restaurants once
//   Future<List<Map<String, dynamic>>> getAllRestaurants() async {
//     final snapshot = await _restaurants.get();
//     return snapshot.docs.map((doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       data['id'] = doc.id;
//       return data;
//     }).toList();
//   }
//
//   /// Listen to restaurant list in real time
//   Stream<List<Map<String, dynamic>>> watchRestaurants() {
//     return _restaurants.snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         data['id'] = doc.id;
//         return data;
//       }).toList();
//     });
//   }
//
//   /// Get single restaurant by ID
//   Future<Map<String, dynamic>?> getRestaurantById(String id) async {
//     final doc = await _restaurants.doc(id).get();
//     if (!doc.exists) return null;
//     final data = doc.data() as Map<String, dynamic>;
//     data['id'] = doc.id;
//     return data;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_items.dart';
import '../models/restaurant.dart';

class RestaurantRepository {
  final _db = FirebaseFirestore.instance;
  CollectionReference get _restaurants => _db.collection('restaurants');

  Stream<List<Restaurant>> allRestaurants() => _db
      .collection('restaurants')
      .snapshots()
      .map(
        (s) => s.docs.map((d) => Restaurant.fromMap(d.id, d.data())).toList(),
      );

  /// Stream menu items for a restaurant (with debug prints)
  Stream<List<MenuItem>> menu(String restaurantId) {
    print("Starting menu stream for restaurant: $restaurantId");
    return _restaurants
        .doc(restaurantId)
        .collection('menu')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          print("Menu snapshot received: ${snapshot.docs.length} docs");
          final list = snapshot.docs.map((doc) {
            final data = {'restaurantId': restaurantId, ...doc.data()};
            print("Menu item loaded: ${doc.id}, data: $data");
            return MenuItem.fromMap(doc.id, data);
          }).toList();
          print("Mapped ${list.length} menu items");
          return list;
        });
  }

  Future<void> upsertMenuItem(String rid, MenuItem item) async {
    final ref = _restaurants
        .doc(rid)
        .collection('menu')
        .doc(item.id.isEmpty ? null : item.id);
    print("Upserting menu item ${item.id} for restaurant $rid");
    await ref.set(item.toMap(), SetOptions(merge: true));
    print("Menu item upserted successfully");
  }
}
