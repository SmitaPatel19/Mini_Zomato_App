import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'delivery_map_event.dart';
import 'delivery_map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final String deliveryId; // delivery_partners/{did}

  MapBloc({required this.deliveryId}) : super(const MapState()) {
    on<LoadMapEvent>(_onLoadMap);
    on<UpdateDriverLocationEvent>(_onUpdateLocation);
  }

  void _onLoadMap(LoadMapEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("delivery_partners")
          .doc(deliveryId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        final loc = data['location'] as Map<String, dynamic>?;

        if (loc != null && loc['lat'] != null && loc['lng'] != null) {
          emit(state.copyWith(
            currentLat: (loc['lat'] as num).toDouble(),
            currentLng: (loc['lng'] as num).toDouble(),
            isLoading: false,
          ));
          return; // stop here
        }
      }

      // fallback if no location exists
      emit(state.copyWith(
        currentLat: event.lat,
        currentLng: event.lng,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onUpdateLocation(UpdateDriverLocationEvent event, Emitter<MapState> emit) async {
    emit(state.copyWith(
      currentLat: event.lat,
      currentLng: event.lng,
      isLoading: true,
    ));

    try {
      await FirebaseFirestore.instance
          .collection("delivery_partners")
          .doc(deliveryId)
          .update({
        "location": {
          "lat": event.lat,
          "lng": event.lng,
          "updatedAt": FieldValue.serverTimestamp(),
        },
        "active": true,
      });

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
