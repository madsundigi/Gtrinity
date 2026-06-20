part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}

class ForgotEmailChanged extends ForgotPasswordEvent {
  final String email;
  ForgotEmailChanged(this.email);
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordSubmitted(this.email);
}

