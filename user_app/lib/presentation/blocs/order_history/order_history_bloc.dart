import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/order.dart';
import '../../../data/repositories/order_repository.dart';
import 'order_history_event.dart';
import 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderRepository repo;
  OrderHistoryBloc(this.repo) : super(OHLoading()) {
    on<LoadOrderHistory>((e, emit) async {
      emit(OHLoading());
      await emit.forEach<List<Order>>(
        repo.userOrders(e.userId),
        onData: (orders) => OHLoaded(orders),
        onError: (err, st) => OHError(err.toString()),
      );
    });
  }
}
