import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(initialCart) {
    on<AddToCart>((e, emit) {
      final lines = [...state.lines];
      final idx = lines.indexWhere((l) => l.item.id == e.item.id);
      if (idx == -1)
        lines.add(CartItem(e.item, 1));
      else
        lines[idx] = CartItem(lines[idx].item, lines[idx].qty + 1);
      emit(CartState(lines));
    });
    on<RemoveFromCart>((e, emit) {
      emit(
        CartState(state.lines.where((l) => l.item.id != e.menuItemId).toList()),
      );
    });
    on<ChangeQty>((e, emit) {
      final lines = state.lines
          .map((l) => l.item.id == e.menuItemId ? CartItem(l.item, e.qty) : l)
          .where((l) => l.qty > 0)
          .toList();
      emit(CartState(lines));
    });
    on<ClearCart>((e, emit) => emit(initialCart));
  }
}
