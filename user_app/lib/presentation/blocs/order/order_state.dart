import 'package:equatable/equatable.dart';

sealed class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderIdle extends OrderState {}

class OrderPlacing extends OrderState {}

class OrderPlaced extends OrderState {
  final String orderId;
  OrderPlaced(this.orderId);
}

class OrderError extends OrderState {
  final String msg;
  OrderError(this.msg);
}
