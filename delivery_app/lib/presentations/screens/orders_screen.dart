import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/presentations/screens/map_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../core_services/firebase_services.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/orders_repository.dart';
import '../blocs/map/delivery_map_bloc.dart';
import '../blocs/map/delivery_map_event.dart';
import '../blocs/orders/delivery_orders_bloc.dart';
import '../blocs/orders/delivery_orders_event.dart';
import '../blocs/orders/delivery_orders_state.dart';
import '../blocs/status/delivery_status_bloc.dart';
import '../blocs/status/delivery_status_event.dart';
import '../blocs/status/delivery_status_state.dart';
import '../widgets/order_toggle_button.dart';

class DeliveryOrdersPage extends StatefulWidget {
  const DeliveryOrdersPage({super.key});

  @override
  State<DeliveryOrdersPage> createState() => _DeliveryOrdersPageState();
}

class _DeliveryOrdersPageState extends State<DeliveryOrdersPage> {
  @override
  void initState() {
    super.initState();
    _listenForNewOrders();
    // Listen for notification clicks
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Notification clicked: ${message.data}');
      // Example: Navigate to orders page
      // Navigator.pushNamed(context, '/orders');
    });
  }

  void _listenForNewOrders() {
    final currentDeliveryId = context.read<AuthRepository>().currentDeliveryId;

    FirebaseFirestore.instance
        .collection('orders')
        .where('assignedRiderId', isEqualTo: currentDeliveryId)
        .where('status', isEqualTo: 'ready_for_pickup')
        .snapshots()
        .listen((snapshot) {
          for (var docChange in snapshot.docChanges) {
            if (docChange.type == DocumentChangeType.added) {
              final order = docChange.doc.data();
              flutterLocalNotificationsPlugin.show(
                order.hashCode,
                "New Order Received",
                "You have a new order from ${order?['restaurantId']}",
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'restaurant_channel',
                    'Order Notifications',
                    importance: Importance.high,
                    priority: Priority.high,
                  ),
                ),
              );
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DeliveryOrdersBloc(
            context.read<OrderRepository>(), // repo
            context.read<AuthRepository>().currentDeliveryId ??
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
          title: const Text("Assigned Orders"),
          actions: [
            IconButton(
              icon: const Icon(Icons.location_on_outlined),
              onPressed: () {
                final deliveryId = context
                    .read<AuthRepository>()
                    .currentDeliveryId!;
                print(".>>>>");
                print(deliveryId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) =>
                          MapBloc(deliveryId: deliveryId)
                            ..add(LoadMapEvent(lat: 0.0, lng: 0.0)),
                      child: const MapScreen(),
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
          child: BlocBuilder<DeliveryOrdersBloc, DeliveryOrdersState>(
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
                              Text("Restaurant: ${order.restaurantId}"),
                              Text(
                                order.status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              OrderActionToggle(orderId: order.id),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text("No orders yet"));
              }
            },
          ),
        ),
      ),
    );
  }
}
