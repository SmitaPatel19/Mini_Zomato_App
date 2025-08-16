import 'package:equatable/equatable.dart';

import '../../../data/models/order_model.dart';

sealed class IncomingOrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class IncomingLoading extends IncomingOrdersState {}

class IncomingLoaded extends IncomingOrdersState {
  final List<Order> orders;
  IncomingLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}

class IncomingError extends IncomingOrdersState {
  final String msg;
  IncomingError(this.msg);
}
