import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/data/models/restaurant.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/restaurant_repository.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/menu/menu_bloc.dart';
import '../blocs/menu/menu_event.dart';
import '../blocs/menu/menu_state.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/order/order_bloc.dart';
import '../blocs/order/order_event.dart';
import '../blocs/order/order_state.dart';

class RestaurantScreen extends StatelessWidget {
  final Restaurant rid;
  final UserProfile profile;
  const RestaurantScreen({super.key, required this.rid, required this.profile});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              MenuBloc(context.read<RestaurantRepository>())
                ..add(LoadMenu(rid.id)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(profile.name)),
        body: Column(
          children: [
            // Restaurant Details Section
            _buildRestaurantDetails(rid),

            // Menu Section Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text('Menu', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(width: 8),
                  const Icon(Icons.restaurant_menu),
                ],
              ),
            ),

            // Menu Items List
            Expanded(
              child: BlocBuilder<MenuBloc, MenuState>(
                builder: (_, state) {
                  if (state is MenuLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MenuLoaded && state.items.isEmpty) {
                    return const Center(child: Text('No menu items available'));
                  }

                  final menu = (state as MenuLoaded).items;
                  return ListView.builder(
                    itemCount: menu.length,
                    itemBuilder: (context, i) {
                      final m = menu[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: m.imageUrl != ""
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(m.imageUrl),
                                  radius: 30,
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.fastfood),
                                  radius: 30,
                                ),
                          title: Text(
                            m.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(m.isAvailable ?? ''),
                              const SizedBox(height: 4),
                              Text(
                                '₹${m.price}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              context.read<CartBloc>().add(AddToCart(m));
                            },
                            child: const Text('Add +'),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            BlocBuilder<CartBloc, CartState>(
              builder: (_, cState) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total: ₹${cState.total}'),
                      ElevatedButton(
                        onPressed: cState.lines.isEmpty
                            ? null
                            : () {
                                context.read<OrderBloc>().add(
                                  PlaceOrder(rid.id, profile.uid, cState.lines),
                                );
                              },
                        child: const Text('Place Order'),
                      ),
                    ],
                  ),
                );
              },
            ),
            BlocListener<OrderBloc, OrderState>(
              listener: (context, s) {
                if (s is OrderPlaced) {
                  context.read<CartBloc>().add(ClearCart());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Order ${s.orderId} placed')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantDetails(Restaurant restaurant) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.restaurant, size: 40),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.black87,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.phone.toString() ?? 'XXXXXXXXXX',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    Text(
                      '(${restaurant.isOpen})',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            restaurant.address ?? 'No address provided',
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
