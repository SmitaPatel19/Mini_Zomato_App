import 'package:flutter/material.dart';
import '../data/models/user_profile.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/restaurant_screen.dart';
import '../presentation/screens/cart_screen.dart';
import '../presentation/screens/order_placed_screen.dart';
import '../presentation/screens/my_orders_screen.dart';

class AppRouter {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const restaurant = '/restaurant';
  static const cart = '/cart';
  static const placed = '/orderPlaced';
  static const orders = '/orders';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        final profile = settings.arguments as UserProfile?;
        if (profile == null) {

          return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
        return MaterialPageRoute(builder: (_) => HomeScreen(profile: profile));
      case restaurant:
        final args = settings.arguments as Map<String, dynamic>;
        final rid = args['rid'];
        final profile = args['profile'] as UserProfile;
        return MaterialPageRoute(
          builder: (_) => RestaurantScreen(rid: rid, profile: profile),
        );
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case placed:
        return MaterialPageRoute(builder: (_) => const OrderPlacedScreen());
      case orders:
        return MaterialPageRoute(builder: (_) => const MyOrdersScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
