import 'package:equatable/equatable.dart';

import '../../../data/models/menu_items.dart';

class CartItem extends Equatable {
  final MenuItem item;
  final int qty;
  const CartItem(this.item, this.qty);
  @override
  List<Object?> get props => [item, qty];
}

sealed class CartEvent {}

class AddToCart extends CartEvent {
  final MenuItem item;
  AddToCart(this.item);
}

class RemoveFromCart extends CartEvent {
  final String menuItemId;
  RemoveFromCart(this.menuItemId);
}

class ChangeQty extends CartEvent {
  final String menuItemId;
  final int qty;
  ChangeQty(this.menuItemId, this.qty);
}

class ClearCart extends CartEvent {}
