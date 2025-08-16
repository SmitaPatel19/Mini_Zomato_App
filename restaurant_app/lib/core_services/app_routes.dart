import 'package:flutter/material.dart';
import '../presentations/screens/home_screen.dart';
import '../presentations/screens/login_screen.dart';
import '../presentations/screens/order_detail_screen.dart';
import '../presentations/screens/orders_screen.dart';
import '../presentations/screens/splash_screen.dart';

class AppRouter {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const orders = '/orders';
  static const orderDetail = '/order-detail';

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    home: (_) => const HomeScreen(),
    orders: (_) => const OrdersScreen(),
    orderDetail: (_) => const OrderDetailScreen(),
  };
}