import 'package:equatable/equatable.dart';

import '../../../data/models/restaurant.dart';

sealed class RestaurantListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RListLoading extends RestaurantListState {}

class RListLoaded extends RestaurantListState {
  final List<Restaurant> data;
  RListLoaded(this.data);
  @override
  List<Object?> get props => [data];
}

class RListError extends RestaurantListState {
  final String msg;
  RListError(this.msg);
}
