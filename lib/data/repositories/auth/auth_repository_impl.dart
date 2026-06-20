import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/utils/safe_api_call.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../models/auth/LoginRequest.dart';
import '../../models/auth/LoginResponse.dart';
import '../../remote/api_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  AuthRepositoryImpl(this._apiClient);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    return safeApiCall(
      () => _apiClient.dio.post(
        ApiConstants.loginEndpoint,
        data: request.toJson(),
      ),
      (data) => LoginResponse.fromJson(data),
    );
  }

  @override
  Future<bool> logout() async {
    return safeApiCall(
      () => _apiClient.dio.post(ApiConstants.logoutEndpoint),
      (data) => data['success'] ?? false,
    );
  }

  @override
  Future<User> getProfile() async {
    return safeApiCall(
      () => _apiClient.dio.get(ApiConstants.profileEndpoint),
      (data) => User.fromJson(data['data']['user']),
    );
  }

  @override
  Future<User> updateProfile({
    required Map<String, String> fields,
    Map<String, File>? files,
  }) async {
    final formMap = <String, dynamic>{...fields};
    if (files != null) {
      for (final entry in files.entries) {
        final fileName = entry.value.path.split('/').last;
        formMap[entry.key] = await MultipartFile.fromFile(
          entry.value.path,
          filename: fileName,
        );
      }
    }
    final formData = FormData.fromMap(formMap);
    return safeApiCall(
      () => _apiClient.dio.post(
        ApiConstants.updateProfileEndpoint,
        data: formData,
      ),
      (data) => User.fromJson(data['data']['user']),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getClients() async {
    return safeApiCall(
      () => _apiClient.dio.get(ApiConstants.clientsEndpoint),
      (data) => List<Map<String, dynamic>>.from(data['data'] ?? const []),
    );
  }

  @override
  Future<User> completeOnboarding({
    required Map<String, String> fields,
    Map<String, File>? files,
  }) async {
    final formMap = <String, dynamic>{...fields};
    if (files != null) {
      for (final entry in files.entries) {
        final fileName = entry.value.path.split('/').last;
        formMap[entry.key] =
            await MultipartFile.fromFile(entry.value.path, filename: fileName);
      }
    }
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.completeOnboardingEndpoint,
        data: FormData.fromMap(formMap),
      );
      return User.fromJson(response.data['data']['user']);
    } on DioException catch (e) {
      // 422 -> per-field validation errors for the UI to highlight.
      final data = e.response?.data;
      if (e.response?.statusCode == 422 && data is Map && data['errors'] is Map) {
        final raw = data['errors'] as Map;
        final flat = <String, String>{};
        raw.forEach((key, value) {
          final msg = value is List && value.isNotEmpty
              ? value.first.toString()
              : value.toString();
          flat[key.toString()] = msg;
        });
        throw OnboardingValidation(flat);
      }
      if (data is Map && data['message'] != null) {
        throw data['message'].toString();
      }
      rethrow;
    }
  }
}
