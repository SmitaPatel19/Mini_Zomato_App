import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/presentation/screens/restaurant_screen.dart';
import '../../core_services/app_routes.dart';
import '../../data/models/user_profile.dart';
import '../blocs/restaurant_list/restaurant_list_bloc.dart';
import '../blocs/restaurant_list/restaurant_list_event.dart';
import '../blocs/restaurant_list/restaurant_list_state.dart';
import '../../../data/repositories/restaurant_repository.dart';

class HomeScreen extends StatelessWidget {
  final UserProfile profile;
  const HomeScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<RestaurantRepository>();

    return BlocProvider(
      create: (_) => RestaurantListBloc(repository)..add(LoadRestaurants()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Restaurants'),
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.orders),
              icon: const Icon(Icons.history),
            ),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.cart),
              icon: const Icon(Icons.shopping_cart),
            ),
          ],
        ),
        body: BlocBuilder<RestaurantListBloc, RestaurantListState>(
          builder: (context, state) {
            if (state is RListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RListLoaded) {
              print(".......");
              final rest = state.data;
              if (rest.isEmpty)
                return const Center(child: Text('No Restaurant'));
              return ListView.builder(
                itemCount: rest.length,
                itemBuilder: (context, i) {
                  print(",,,,,,,");
                  final r = rest[i];
                  return ListTile(
                    title: Text(r.name ?? "Name"),
                    subtitle: Text(r.address ?? "address"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RestaurantScreen(rid: r, profile: profile),
                      ),
                    ),
                  );
                },
              );
            } else if (state is RListError) {
              print('Error: ${state.msg}');
              return Center(child: Text('Error: ${state.msg}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
