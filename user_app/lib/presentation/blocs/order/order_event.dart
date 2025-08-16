import '../cart/cart_event.dart';

sealed class OrderEvent {}

class PlaceOrder extends OrderEvent {
  final String restaurantId;
  final String userId;
  final List<CartItem> items;
  PlaceOrder(this.restaurantId, this.userId, this.items);
}
