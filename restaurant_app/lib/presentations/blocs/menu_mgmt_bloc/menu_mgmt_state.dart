import 'package:equatable/equatable.dart';
import '../../../data/models/menu_item.dart';

abstract class MenuMgmtState extends Equatable {
  const MenuMgmtState();

  @override
  List<Object?> get props => [];
}

class MenuLoading extends MenuMgmtState {}

class MenuLoaded extends MenuMgmtState {
  final List<MenuItem> menuItems; // <-- use MenuItem

  const MenuLoaded(this.menuItems);

  @override
  List<Object?> get props => [menuItems];
}

class MenuError extends MenuMgmtState {
  final String error;

  const MenuError(this.error);

  @override
  List<Object?> get props => [error];
}
