part of 'forgot_password_bloc.dart';

@immutable
class ForgotPasswordState {
  final String email;
  final String? emailError;
  final bool isLoading;

  const ForgotPasswordState({
    this.email = '',
    this.emailError,
    this.isLoading = false,
  });

  ForgotPasswordState copyWith({
    String? email,
    String? emailError,
    bool? isLoading,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      emailError: emailError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

