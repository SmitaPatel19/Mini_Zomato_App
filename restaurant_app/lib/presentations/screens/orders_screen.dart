import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/restaurant_repository.dart';
import '../blocs/incoming_orders/incoming_orders_bloc.dart';
import '../blocs/menu_mgmt_bloc/menu_mgmt_bloc.dart';
import '../blocs/menu_mgmt_bloc/menu_mgmt_event.dart';
import '../blocs/order_action/order_action_bloc.dart';
import '../blocs/order_action/order_action_event.dart';
import '../blocs/incoming_orders/incoming_orders_event.dart';
import '../blocs/incoming_orders/incoming_orders_state.dart';
import '../blocs/order_action/order_action_state.dart';
import 'menu_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => IncomingOrdersBloc(
            context.read<OrderRepository>(), // repo
            context.read<AuthRepository>().currentRestaurantId ??
                "0", // restaurant ID
          )..add(LoadIncoming()),
        ),
        BlocProvider(
          create: (_) => OrderActionBloc(
            context.read<OrderRepository>(), // repo
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Incoming Orders'),
          actions: [
            IconButton(
              icon: const Icon(Icons.restaurant_menu),
              onPressed: () {
                final restaurantId = context
                    .read<AuthRepository>()
                    .currentRestaurantId!;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) =>
                          MenuMgmtBloc(context.read<RestaurantRepository>())
                            ..add(LoadMenuItems(restaurantId)),
                      child: MenuScreen(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocListener<OrderActionBloc, ActionState>(
          listener: (context, state) {
            // Show snackbar on success
            if (state is OrderActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Action successful'),
                  backgroundColor: Colors.green,
                ),
              );
            }
            // Optional: show snackbar on failure
            else if (state is OrderActionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error ?? 'Action failed'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<IncomingOrdersBloc, IncomingOrdersState>(
            builder: (context, state) {
              if (state is IncomingLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is IncomingLoaded) {
                return ListView.builder(
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/order-detail',
                          arguments: order.id,
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                            'Order #${order.id}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Text(
                                order.items.join(', '),
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                order.status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      context.read<OrderActionBloc>().add(
                                        AcceptOrder(order.id),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,

                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      context.read<OrderActionBloc>().add(
                                        RejectOrder(order.id),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,

                                    icon: const Icon(
                                      Icons.local_dining,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () {
                                      context.read<OrderActionBloc>().add(
                                        MarkPreparing(order.id),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,

                                    icon: const Icon(
                                      Icons.done_all,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      context.read<OrderActionBloc>().add(
                                        MarkReady(order.id),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // trailing: Container(
                          //   width: MediaQuery.of(context).size.width * 0.5,
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //       IconButton(
                          //         padding: EdgeInsets.zero,
                          //         icon: const Icon(Icons.check, color: Colors.green),
                          //         onPressed: () {
                          //           context.read<OrderActionBloc>().add(
                          //             AcceptOrder(order.id),
                          //           );
                          //         },
                          //       ),
                          //       IconButton(
                          //         padding: EdgeInsets.zero,
                          //
                          //         icon: const Icon(Icons.close, color: Colors.red),
                          //         onPressed: () {
                          //           context.read<OrderActionBloc>().add(
                          //             RejectOrder(order.id),
                          //           );
                          //         },
                          //       ),
                          //       IconButton(
                          //         padding: EdgeInsets.zero,
                          //
                          //         icon: const Icon(Icons.local_dining, color: Colors.orange),
                          //         onPressed: () {
                          //           context.read<OrderActionBloc>().add(
                          //             MarkPreparing(order.id),
                          //           );
                          //         },
                          //       ),
                          //       IconButton(
                          //         padding: EdgeInsets.zero,
                          //
                          //         icon: const Icon(Icons.done_all, color: Colors.blue),
                          //         onPressed: () {
                          //           context.read<OrderActionBloc>().add(
                          //             MarkReady(order.id),
                          //           );
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No orders yet'));
              }
            },
          ),
        ),
      ),
    );
  }
}
