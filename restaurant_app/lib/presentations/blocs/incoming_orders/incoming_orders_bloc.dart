import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';
import 'incoming_orders_event.dart';
import 'incoming_orders_state.dart';

class IncomingOrdersBloc
    extends Bloc<IncomingOrdersEvent, IncomingOrdersState> {
  final OrderRepository repo;
  final String restaurantId;
  StreamSubscription? _sub;

  IncomingOrdersBloc(this.repo, this.restaurantId) : super(IncomingLoading()) {
    on<LoadIncoming>(_onLoadIncoming);
  }

  Future<void> _onLoadIncoming(
    LoadIncoming event,
    Emitter<IncomingOrdersState> emit,
  ) async {
    emit(IncomingLoading());

    await emit.forEach<List<Order>>(
      repo.restaurantIncoming(restaurantId),
      onData: (orders) => IncomingLoaded(orders),
      onError: (error, stackTrace) => IncomingError(error.toString()),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
