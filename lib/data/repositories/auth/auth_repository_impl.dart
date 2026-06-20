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
}
