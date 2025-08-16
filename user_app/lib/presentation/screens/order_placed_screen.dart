import 'package:flutter/material.dart';

import '../../core_services/app_routes.dart';

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Placed')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 96, color: Colors.green),
            const SizedBox(height: 12),
            const Text(
              'Your order has been placed!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.home,
                (_) => false,
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
