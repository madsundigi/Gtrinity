part of 'auth_bloc.dart';

@immutable
class AuthState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const AuthState({
    this.email = "guard@example.com",
    this.password = "password123",
    this.emailError,
    this.passwordError,
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  AuthState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}
