import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/presentations/blocs/auth/auth_bloc.dart';

import 'core_services/app_routes.dart';
import 'core_services/firebase_services.dart';
import 'core_services/notifications_services.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/restaurant_repository.dart';

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
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        Provider<OrderRepository>(create: (_) => OrderRepository()),
        Provider<RestaurantRepository>(create: (_) => RestaurantRepository()),
        BlocProvider(
          create: (context) => AuthBloc(context.read<AuthRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Restaurant App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.red),
        initialRoute: AppRouter.splash,
        routes: AppRouter.routes,
      ),
    );
  }
}
