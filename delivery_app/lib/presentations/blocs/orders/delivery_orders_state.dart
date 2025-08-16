import 'package:equatable/equatable.dart';

import '../../../data/models/order_model.dart';

sealed class DeliveryOrdersState extends Equatable { @override List<Object?> get props => []; }
class IncomingLoading extends DeliveryOrdersState {}
class IncomingLoaded extends DeliveryOrdersState { final List<Order> orders; IncomingLoaded(this.orders); @override List<Object?> get props => [orders]; }
class IncomingError extends DeliveryOrdersState { final String msg; IncomingError(this.msg); }


class OrdersError extends DeliveryOrdersState {
  final String message;

  OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}
