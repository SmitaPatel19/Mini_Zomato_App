import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/presentation/blocs/restaurant_list/restaurant_list_event.dart';
import 'package:user_app/presentation/blocs/restaurant_list/restaurant_list_state.dart';
import '../../../data/models/restaurant.dart';
import '../../../data/repositories/restaurant_repository.dart';

class RestaurantListBloc
    extends Bloc<RestaurantListEvent, RestaurantListState> {
  final RestaurantRepository repo;
  StreamSubscription? _sub;

  RestaurantListBloc(this.repo) : super(RListLoading()) {
    on<LoadRestaurants>((event, emit) async {
      emit(RListLoading());
      await emit.forEach<List<Restaurant>>(
        repo.allRestaurants(),
        onData: (data) => RListLoaded(data),
        onError: (err, st) => RListError(err.toString()),
      );
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
