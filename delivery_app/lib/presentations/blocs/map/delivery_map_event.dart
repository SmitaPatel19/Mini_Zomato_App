import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMapEvent extends MapEvent {
  final double lat;
  final double lng;

  LoadMapEvent({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];
}

class UpdateDriverLocationEvent extends MapEvent {
  final double lat;
  final double lng;

  UpdateDriverLocationEvent({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];
}
