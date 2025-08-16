import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item.dart';
import '../models/restaurant.dart';

class RestaurantRepository {
  final _db = FirebaseFirestore.instance;

  /// Fetch restaurants owned by a specific owner
  Stream<List<Restaurant>> fetchOwnedRestaurant(String ownerUid) => _db
      .collection('restaurants')
      .where('ownerUid', isEqualTo: ownerUid)
      .snapshots()
      .map(
        (s) => s.docs.map((d) => Restaurant.fromMap(d.id, d.data())).toList(),
      );

  /// Fetch menu items for a specific restaurant
  Stream<List<MenuItem>> fetchMenu(String restaurantId) => _db
      .collection('restaurants')
      .doc(restaurantId)
      .collection('menu')
      .snapshots()
      .map(
        (s) => s.docs
            .map(
              (d) => MenuItem.fromMap(d.id, {
                'restaurantId': restaurantId,
                ...d.data(),
              }),
            )
            .toList(),
      );

  /// Add a new menu item
  Future<void> addMenuItem(String restaurantId, MenuItem item) async {
    final ref = _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .doc(); // auto ID
    await ref.set(item.copyWith(id: ref.id).toMap());
  }

  /// Update an existing menu item
  Future<void> updateMenuItem(
    String restaurantId,
    String menuItemId,
    MenuItem item,
  ) async {
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .doc(menuItemId)
        .update(item.toMap());
  }

  /// Delete a menu item
  Future<void> deleteMenuItem(String restaurantId, String menuItemId) async {
    await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .doc(menuItemId)
        .delete();
  }

  /// Add or update a menu item (Upsert)
  Future<void> upsertMenuItem(String restaurantId, MenuItem item) async {
    final ref = _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .doc(item.id.isEmpty ? null : item.id);
    await ref.set(item.toMap(), SetOptions(merge: true));
  }

  /// Get a single menu item by ID
  Future<MenuItem?> getMenuItemById(
    String restaurantId,
    String menuItemId,
  ) async {
    final doc = await _db
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .doc(menuItemId)
        .get();
    if (!doc.exists) return null;
    return MenuItem.fromMap(doc.id, {
      'restaurantId': restaurantId,
      ...doc.data()!,
    });
  }
}
