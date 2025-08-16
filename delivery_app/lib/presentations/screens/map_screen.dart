import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/map/delivery_map_bloc.dart';
import '../blocs/map/delivery_map_event.dart';
import '../blocs/map/delivery_map_state.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Map")),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state.currentLat == null || state.currentLng == null) {
            return const Center(child: Text("No location loaded"));
          }
          return Center(
            child: Text(
              "Driver at: ${state.currentLat}, ${state.currentLng}",
              style: const TextStyle(fontSize: 18),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mock: Move driver slightly
          context.read<MapBloc>().add(UpdateDriverLocationEvent(
            lat: 28.61 + (DateTime.now().second * 0.0001),
            lng: 77.20 + (DateTime.now().second * 0.0001),
          ));
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
