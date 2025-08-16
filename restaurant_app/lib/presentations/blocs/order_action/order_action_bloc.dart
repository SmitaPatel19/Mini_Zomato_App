import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/order_repository.dart';
import 'order_action_event.dart';
import 'order_action_state.dart';

class OrderActionBloc extends Bloc<OrderActionEvent, ActionState> {
  final OrderRepository repo;

  OrderActionBloc(this.repo) : super(ActionIdle()) {
    on<AcceptOrder>((e, emit) async {
      await _updateStatus(e.orderId, 'accepted', emit);
    });
    on<RejectOrder>((e, emit) async {
      await _updateStatus(e.orderId, 'rejected', emit);
    });
    on<MarkPreparing>((e, emit) async {
      await _updateStatus(e.orderId, 'preparing', emit);
    });
    on<MarkReady>((e, emit) async {
      await _updateStatus(e.orderId, 'ready_for_pickup', emit);
    });
  }

  Future<void> _updateStatus(String orderId, String status, Emitter<ActionState> emit) async {
    emit(ActionBusy());
    try {
      await repo.updateStatus(orderId, status, riderId: "cmetl4uy8aVG9Y9x8pgLQfSZ4Vy1");
      emit(OrderActionSuccess("Order $orderId marked as $status"));
    } catch (e) {
      emit(OrderActionFailure(e.toString()));
    } finally {
      // Optional: go back to idle after short delay
      await Future.delayed(const Duration(milliseconds: 200));
      emit(ActionIdle());
    }
  }
}