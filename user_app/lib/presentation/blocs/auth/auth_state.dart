import 'package:equatable/equatable.dart';

import '../../../data/models/user_profile.dart';

sealed class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserProfile profile;
  AuthAuthenticated(this.profile);
  @override
  List<Object?> get props => [profile];
}

class AuthUnauthenticated extends AuthState {
  final String? message;
  AuthUnauthenticated([this.message]);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
