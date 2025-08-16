import 'package:equatable/equatable.dart';
import 'cart_event.dart';

class CartState extends Equatable {
  final List<CartItem> lines;
  const CartState(this.lines);
  num get total => lines.fold(0, (s, l) => s + l.item.price * l.qty);
  @override
  List<Object?> get props => [lines];
}

const CartState initialCart = CartState([]);
