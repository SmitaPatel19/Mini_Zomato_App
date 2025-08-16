import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core_services/app_routes.dart';
import '../../data/repositories/auth_repository.dart';
import '../../main.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final currentRestaurantId = context
        .read<AuthRepository>()
        .currentRestaurantId;

    FirebaseFirestore.instance
        .collection('orders')
        .where('restaurantId', isEqualTo: currentRestaurantId)
        .where(
          'status',
          whereIn: [
            'pending',
            'placed',
            'accepted',
            'preparing',
            'ready_for_pickup',
            'picked',
            'delivered',
          ],
        )
        .snapshots()
        .listen((snapshot) {
          for (var docChange in snapshot.docChanges) {
            if (docChange.type == DocumentChangeType.added) {
              final order = docChange.doc.data();
              flutterLocalNotificationsPlugin.show(
                order.hashCode,
                "New Order Received",
                "You have a new order from ${order?['userId']}",
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add((SignOutRequested()));
              Navigator.pushReplacementNamed(context, AppRouter.login);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Restaurant App'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.orders);
              },
              child: const Text('View Orders'),
            ),
          ],
        ),
      ),
    );
  }
}
