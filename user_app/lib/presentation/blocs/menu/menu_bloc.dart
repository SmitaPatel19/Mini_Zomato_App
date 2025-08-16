import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/menu_items.dart';
import '../../../data/repositories/restaurant_repository.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final RestaurantRepository repo;
  MenuBloc(this.repo) : super(MenuLoading()) {
    on<LoadMenu>((e, emit) async {
      emit(MenuLoading());
      await emit.forEach<List<MenuItem>>(
        repo.menu(e.restaurantId),
        onData: (items) => MenuLoaded(items),
        onError: (err, st) => MenuError(err.toString()),
      );
    });
  }
}
