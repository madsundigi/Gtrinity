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
}
