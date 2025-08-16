import 'package:equatable/equatable.dart';

import '../../../data/models/order.dart';

sealed class OrderHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OHLoading extends OrderHistoryState {}

class OHLoaded extends OrderHistoryState {
  final List<Order> data;
  OHLoaded(this.data);
  @override
  List<Object?> get props => [data];
}

class OHError extends OrderHistoryState {
  final String msg;
  OHError(this.msg);
}
