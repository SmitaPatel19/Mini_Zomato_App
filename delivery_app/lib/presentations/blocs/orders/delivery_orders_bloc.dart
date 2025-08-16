import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/orders_repository.dart';
import 'delivery_orders_event.dart';
import 'delivery_orders_state.dart';
class DeliveryOrdersBloc extends Bloc<DeliveryOrdersEvent, DeliveryOrdersState> {

  final OrderRepository repo;
  final String deliveryId;
  StreamSubscription? _sub;

DeliveryOrdersBloc(this.repo, this.deliveryId) : super(IncomingLoading()) {
    on<LoadIncoming>(_onLoadIncoming);
  }

  Future<void> _onLoadIncoming(
      LoadIncoming event, Emitter<DeliveryOrdersState> emit) async {
    emit(IncomingLoading());

    await emit.forEach<List<Order>>(
      repo.riderOrders(deliveryId),
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
