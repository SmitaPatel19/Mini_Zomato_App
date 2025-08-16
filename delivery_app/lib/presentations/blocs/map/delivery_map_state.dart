import 'package:equatable/equatable.dart';

class MapState extends Equatable {
  final double? currentLat;
  final double? currentLng;
  final bool isLoading;

  const MapState({
    this.currentLat,
    this.currentLng,
    this.isLoading = false,
  });

  MapState copyWith({
    double? currentLat,
    double? currentLng,
    bool? isLoading,
  }) {
    return MapState(
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [currentLat, currentLng, isLoading];
}
