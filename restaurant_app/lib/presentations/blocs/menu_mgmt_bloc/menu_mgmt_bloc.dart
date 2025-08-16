import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/menu_item.dart';
import '../../../data/repositories/restaurant_repository.dart';
import 'menu_mgmt_event.dart';
import 'menu_mgmt_state.dart';

class MenuMgmtBloc extends Bloc<MenuMgmtEvent, MenuMgmtState> {
  final RestaurantRepository menuRepository;
  StreamSubscription<List<MenuItem>>? _menuSubscription;

  MenuMgmtBloc(this.menuRepository) : super(MenuLoading()) {
    on<LoadMenuItems>(_onLoadMenuItems);
    on<AddMenuItem>(_onAddMenuItem);
    on<UpdateMenuItem>(_onUpdateMenuItem);
    on<DeleteMenuItem>(_onDeleteMenuItem);
  }

  Future<void> _onLoadMenuItems(
    LoadMenuItems event,
    Emitter<MenuMgmtState> emit,
  ) async {
    emit(MenuLoading());

    // Cancel previous subscription if any
    _menuSubscription?.cancel();

    await emit.forEach<List<MenuItem>>(
      menuRepository.fetchMenu(event.restaurantId),
      onData: (items) => MenuLoaded(items),
      onError: (error, _) => MenuError(error.toString()),
    );
  }

  Future<void> _onAddMenuItem(
    AddMenuItem event,
    Emitter<MenuMgmtState> emit,
  ) async {
    await menuRepository.addMenuItem(event.restaurantId, event.item);
  }

  Future<void> _onUpdateMenuItem(
    UpdateMenuItem event,
    Emitter<MenuMgmtState> emit,
  ) async {
    await menuRepository.updateMenuItem(
      event.restaurantId,
      event.itemId,
      event.updatedItem,
    );
  }

  Future<void> _onDeleteMenuItem(
    DeleteMenuItem event,
    Emitter<MenuMgmtState> emit,
  ) async {
    await menuRepository.deleteMenuItem(event.restaurantId, event.itemId);
  }

  @override
  Future<void> close() {
    _menuSubscription?.cancel();
    return super.close();
  }
}
