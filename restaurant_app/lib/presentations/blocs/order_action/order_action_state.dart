import 'package:equatable/equatable.dart';

sealed class ActionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActionIdle extends ActionState {}
class ActionBusy extends ActionState {}

class OrderActionSuccess extends ActionState {
  final String message;
  OrderActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class OrderActionFailure extends ActionState {
  final String error;
  OrderActionFailure(this.error);
  @override
  List<Object?> get props => [error];
}
