import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
import 'delivery_auth_event.dart';
import 'delivery_auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;
  StreamSubscription? _sub;
  AuthBloc(this.repo) : super(AuthInitial()) {
    on<AuthStarted>((e, emit) async {
      emit(AuthLoading());
      _sub?.cancel();
      _sub = repo.authState().listen((user) async {
        if (user == null) {
          add(AuthLoggedOut());
        } else {
          final p = await repo.currentProfile();
          if (p != null)
            add(ProfileLoaded(p));
          else
            add(ProfileMissing());
        }
      });
    });
    on<AuthLoggedOut>((_, emit) => emit(AuthUnauthenticated()));
    on<ProfileLoaded>((e, emit) => emit(AuthAuthenticated(e.profile)));
    on<ProfileMissing>(
      (e, emit) => emit(AuthUnauthenticated('Profile missing')),
    );
    on<SignInRequested>((e, emit) async {
      emit(AuthLoading());
      await repo.signIn(e.email, e.pass);
    });
    on<SignUpRequested>((e, emit) async {
      emit(AuthLoading());
      await repo.signUp(e.email, e.pass, name: e.name, role: e.role);
    });
    on<SignOutRequested>((e, emit) async {
      await FirebaseAuth.instance.signOut();
      emit(AuthUnauthenticated());
    });
  }
  @override
  Future<void> close() {
    _sub?.cancel(); // ✅ important
    return super.close();
  }
}
