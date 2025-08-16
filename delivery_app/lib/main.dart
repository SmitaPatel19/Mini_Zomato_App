import 'package:delivery_app/presentations/blocs/auth/delivery_auth_bloc.dart';
import 'package:delivery_app/presentations/screens/login_screen.dart';
import 'package:delivery_app/presentations/screens/map_screen.dart';
import 'package:delivery_app/presentations/screens/order_detail_screen.dart';
import 'package:delivery_app/presentations/screens/orders_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'core_services/firebase_services.dart';
import 'core_services/notifictaions_services.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/orders_repository.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message received: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is ready
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Initialize Firebase
  await configureDependencies();
  await NotificationService().initialize();
  // Initialize FCM & Notifications safely
  runApp(const DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        Provider<OrderRepository>(
          create: (_) => OrderRepository(),
        ),
        // Provider<RestaurantRepository>(
        //   create: (_) => RestaurantRepository(),
        // ),
        BlocProvider(create: (context) => AuthBloc(context.read<AuthRepository>())),
      ],
      child: MaterialApp(
        title: 'Delivery App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.red),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/orders': (context) => const DeliveryOrdersPage(),
          '/map': (context) => const MapScreen(),
          '/order-detail': (context) => const OrderDetailScreen(),
        },
      ),
    );
  }
}
