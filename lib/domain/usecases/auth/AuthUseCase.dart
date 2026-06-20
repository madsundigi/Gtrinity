import '../../../core/constants/app_strings.dart';
import '../../../data/models/auth/LoginRequest.dart';
import '../../../data/models/auth/LoginResponse.dart';
import '../../repositories/auth/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _repository;

  AuthUseCase(this._repository);

  Future<LoginResponse> login(LoginRequest request) {
    return _repository.login(request);
  }

  Future<bool> logout() {
    return _repository.logout();
  }

  ({String? emailError, String? passwordError}) validateForm({
    required String? email,
    required String? password,
  }) {
    final emailError = _validateEmail(email);
    final passwordError = _validatePassword(password);

    return (emailError: emailError, passwordError: passwordError);
  }

  String? validateEmail(String? email) => _validateEmail(email);

  String? _validateEmail(String? email) {
    final value = email?.trim();
    return (value == null || value.isEmpty)
        ? AppStrings.emailRequired
        : !_isValidEmail(value)
        ? AppStrings.emailInvalid
        : null;
  }

  String? _validatePassword(String? password) {
    final value = password?.trim();
    return (value == null || value.isEmpty)
        ? AppStrings.passwordRequired
        : value.length < 6
        ? AppStrings.passwordMinLength
        : null;
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }
}
