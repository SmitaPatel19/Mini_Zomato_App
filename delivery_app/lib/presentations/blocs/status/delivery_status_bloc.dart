import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/orders_repository.dart';
import 'delivery_status_event.dart';
import 'delivery_status_state.dart';


class OrderActionBloc extends Bloc<OrderActionEvent, ActionState> {
  final OrderRepository repo;

  OrderActionBloc(this.repo) : super(ActionIdle()) {
    on<AcceptOrder>((e, emit) async {
      await _updateStatus(e.orderId, 'picked', emit);
    });
    on<RejectOrder>((e, emit) async {
      await _updateStatus(e.orderId, 'delivered', emit);
    });
  }

  Future<void> _updateStatus(String orderId, String status, Emitter<ActionState> emit) async {
    emit(ActionBusy());
    try {
      await repo.updateStatus(orderId, status);
      emit(OrderActionSuccess("Order $orderId marked as $status"));
    } catch (e) {
      emit(OrderActionFailure(e.toString()));
    } finally {
      await Future.delayed(const Duration(milliseconds: 200));
      emit(ActionIdle());
    }
  }
}