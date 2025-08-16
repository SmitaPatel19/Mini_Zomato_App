import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:user_app/presentation/blocs/auth/auth_event.dart';
import 'package:user_app/presentation/blocs/auth/auth_state.dart';
import 'package:user_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:user_app/presentation/blocs/order/order_bloc.dart';
import 'package:user_app/presentation/screens/home_screen.dart';
import 'package:user_app/presentation/screens/login_screen.dart';
import 'core_services/app_routes.dart';
import 'core_services/firebase_services.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/restaurant_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => RestaurantRepository()),
        RepositoryProvider(create: (_) => OrderRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CartBloc()), // provide globally
          BlocProvider(create: (context) => OrderBloc(OrderRepository())),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Zomato - User',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

class RootGate extends StatelessWidget {
  const RootGate({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, s) {
        if (s is AuthLoading || s is AuthInitial)
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        if (s is AuthAuthenticated) return HomeScreen(profile: s.profile);
        return LoginScreen(); // simple email/pass form
      },
    );
  }
}
