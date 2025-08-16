import 'package:equatable/equatable.dart';
import '../../../data/models/menu_item.dart';

abstract class MenuMgmtEvent extends Equatable {
  const MenuMgmtEvent();

  @override
  List<Object?> get props => [];
}

class LoadMenuItems extends MenuMgmtEvent {
  final String restaurantId;
  const LoadMenuItems(this.restaurantId);
  @override
  List<Object?> get props => [restaurantId];
}

class AddMenuItem extends MenuMgmtEvent {
  final String restaurantId;
  final MenuItem item; // <-- now MenuItem
  const AddMenuItem(this.restaurantId, this.item);
  @override
  List<Object?> get props => [restaurantId, item];
}

class UpdateMenuItem extends MenuMgmtEvent {
  final String restaurantId;
  final String itemId;
  final MenuItem updatedItem; // <-- now MenuItem
  const UpdateMenuItem(this.restaurantId, this.itemId, this.updatedItem);
  @override
  List<Object?> get props => [restaurantId, itemId, updatedItem];
}

class DeleteMenuItem extends MenuMgmtEvent {
  final String restaurantId;
  final String itemId;

  const DeleteMenuItem(this.restaurantId, this.itemId);

  @override
  List<Object?> get props => [restaurantId, itemId];
}

