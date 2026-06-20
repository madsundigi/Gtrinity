part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class EmailChanged extends AuthEvent {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends AuthEvent {
  final String password;
  PasswordChanged(this.password);
}

class LoginSubmitted extends AuthEvent {
  final LoginRequest loginRequest;
  LoginSubmitted(this.loginRequest);
}

class ClearMessages extends AuthEvent {}

class ResetAuthForm extends AuthEvent {}
