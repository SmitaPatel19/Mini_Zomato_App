import '../../../data/models/user_profile.dart';

sealed class AuthEvent {}

class AuthStarted extends AuthEvent {} // app start

class SignInRequested extends AuthEvent {
  final String email, pass;
  SignInRequested(this.email, this.pass);
}

class SignUpRequested extends AuthEvent {
  final String email, pass, name, role;
  SignUpRequested(this.email, this.pass, this.name, this.role);
}

class SignOutRequested extends AuthEvent {}

class ProfileLoaded extends AuthEvent {
  final UserProfile profile;
  ProfileLoaded(this.profile);
}

class AuthLoggedOut extends AuthEvent {}

class ProfileMissing extends AuthEvent {}
