import 'dart:io';
import '../../../data/models/auth/LoginRequest.dart';
import '../../../data/models/auth/LoginResponse.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<bool> logout();

  /// Fetches the latest guard profile (user + guard detail + documents).
  Future<User> getProfile();

  /// Updates editable profile fields and/or document files.
  /// [fields] are plain text values; [files] maps a field name (e.g.
  /// 'profile_image', 'security_license') to the picked file.
  Future<User> updateProfile({
    required Map<String, String> fields,
    Map<String, File>? files,
  });

  /// Submits the first-login onboarding. Returns the activated User on success;
  /// throws an [OnboardingValidation] carrying per-field errors on a 422.
  Future<User> completeOnboarding({
    required Map<String, String> fields,
    Map<String, File>? files,
  });
}

/// Raised when onboarding fails server-side validation; [errors] maps each
/// field name to its first message so the UI can highlight it.
class OnboardingValidation implements Exception {
  final Map<String, String> errors;
  OnboardingValidation(this.errors);

  @override
  String toString() => 'Please fix the highlighted fields.';
}
