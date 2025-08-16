// abstract class AuthEvent {}
// class AuthStarted extends AuthEvent {}
// class AuthLoggedIn extends AuthEvent {}
// class AuthLoggedOut extends AuthEvent {}
// class AuthToggleMode extends AuthEvent {} // login/signup toggle
// class AuthSubmit extends AuthEvent {
//   final String email; final String password; final bool login;
//   AuthSubmit(this.email, this.password, this.login);
// }

import '../../../data/models/user_profile.dart';

sealed class AuthEvent {}

class AuthStarted extends AuthEvent {}

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
