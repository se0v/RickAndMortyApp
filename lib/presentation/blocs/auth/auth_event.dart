part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;
  AuthSignIn({required this.email, required this.password});
}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  AuthSignUp({required this.email, required this.password});
}

class AuthSignOut extends AuthEvent {}

class AuthSignedOut extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final AppUser user;
  AuthUserChanged(this.user);
}