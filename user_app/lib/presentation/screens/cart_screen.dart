import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core_services/app_routes.dart';
import '../../data/repositories/order_repository.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/order/order_bloc.dart';
import '../blocs/order/order_event.dart';
import '../blocs/order/order_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<CartBloc>()),
        BlocProvider(create: (_) => OrderBloc(OrderRepository())),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: BlocConsumer<OrderBloc, OrderState>(
          listener: (ctx, state) {
            if (state is OrderPlaced) {
              ctx.read<CartBloc>().add(ClearCart());
              Navigator.pushReplacementNamed(ctx, AppRouter.placed);
            } else if (state is OrderError) {
              ScaffoldMessenger.of(
                ctx,
              ).showSnackBar(SnackBar(content: Text(state.msg)));
            }
          },
          builder: (ctx, orderState) {
            return BlocBuilder<CartBloc, CartState>(
              builder: (ctx2, cart) {
                if (cart.lines.isEmpty) {
                  return const Center(child: Text('Your cart is empty'));
                }

                final items = cart.lines; // ✅ Use the list directly

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          final cartItem = items[i];
                          return ListTile(
                            title: Text(cartItem.item.name),
                            subtitle: Text(
                              '₹${cartItem.item.price} x ${cartItem.qty}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    ctx2.read<CartBloc>().add(
                                      ChangeQty(
                                        cartItem.item.id,
                                        cartItem.qty - 1,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ctx2.read<CartBloc>().add(
                                      ChangeQty(
                                        cartItem.item.id,
                                        cartItem.qty + 1,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                IconButton(
                                  onPressed: () {
                                    ctx2.read<CartBloc>().add(
                                      RemoveFromCart(cartItem.item.id),
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            'Total: ₹${cart.total.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: orderState is OrderPlacing
                                ? null
                                : () {
                                    final uid =
                                        FirebaseAuth.instance.currentUser?.uid;
                                    if (uid == null) {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please login first'),
                                        ),
                                      );
                                      return;
                                    }

                                    ctx.read<OrderBloc>().add(
                                      PlaceOrder(
                                        'r1', // TODO: dynamic restaurantId
                                        uid,
                                        items,
                                      ),
                                    );
                                  },
                            child: orderState is OrderPlacing
                                ? const CircularProgressIndicator()
                                : const Text('Place Order'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
