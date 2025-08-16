import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/order.dart';
import '../../../data/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repo;
  OrderBloc(this.repo) : super(OrderIdle()) {
    on<PlaceOrder>((e, emit) async {
      emit(OrderPlacing());
      final items = e.items
          .map(
            (l) => OrderItem(
              menuItemId: l.item.id,
              name: l.item.name,
              price: l.item.price,
              qty: l.qty,
            ),
          )
          .toList();
      final total = items.fold<num>(0, (s, i) => s + i.price * i.qty);
      final o = Order(
        id: '',
        userId: e.userId,
        restaurantId: e.restaurantId,
        items: items,
        total: total,
        status: 'placed',
        createdAt: DateTime.now(),
      );
      try {
        final id = await repo.placeOrder(o);
        emit(OrderPlaced(id));
      } catch (err) {
        emit(OrderError(err.toString()));
      }
    });
  }
}
