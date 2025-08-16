import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/order_repository.dart';
import '../blocs/order_history/order_history_bloc.dart';
import '../blocs/order_history/order_history_event.dart';
import '../blocs/order_history/order_history_state.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null)
      return const Scaffold(body: Center(child: Text('Please login')));
    return BlocProvider(
      create: (_) =>
          OrderHistoryBloc(OrderRepository())..add(LoadOrderHistory(uid)),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Orders')),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (_, state) {
            if (state is OHLoading)
              return const Center(child: CircularProgressIndicator());
            final orders = (state as OHLoaded).data;
            if (orders.isEmpty) return const Center(child: Text('No orders'));
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (_, i) {
                final o = orders[i];
                return ListTile(
                  title: Text('Order #${o.id}'),
                  subtitle: Text('Status: ${o.status} — Total ₹${o.total}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
