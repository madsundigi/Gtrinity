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
}
