import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/orders_repository.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: FutureBuilder<Order>(
        future: OrderRepository().getOrderById(orderId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ${order.status}',
                  style: TextStyle(
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...order.items.map((item) => Text(
                  '- ${item.name} x${item.qty} (₹${item.price})',
                )),
                const SizedBox(height: 16),
                if (order.status == 'ready_for_pickup')
                  ElevatedButton(
                    onPressed: () async {
                      await OrderRepository().updateStatus(orderId, 'picked');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order status updated!')),
                      );
                    },
                    child: const Text('Picked'),
                  ),

                if (order.status == 'picked')
                  ElevatedButton(
                    onPressed: () async {
                      await OrderRepository().updateStatus(orderId, 'delivered');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order status updated!')),
                      );
                    },
                    child: const Text('Delivered'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'placed':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'ready':
        return Colors.green;
      case 'delivered':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
