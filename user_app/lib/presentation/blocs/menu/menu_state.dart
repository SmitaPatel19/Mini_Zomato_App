import 'package:equatable/equatable.dart';

import '../../../data/models/menu_items.dart';

class MenuState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItem> items;
  MenuLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class MenuError extends MenuState {
  final String msg;
  MenuError(this.msg);
}
