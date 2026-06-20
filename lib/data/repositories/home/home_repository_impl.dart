import 'package:chef_king/data/models/duties/duties_response.dart';
import 'package:chef_king/core/constants/api_constants.dart';
import 'package:chef_king/data/models/home/dashboard_response.dart';
import 'package:chef_king/data/remote/api_client.dart';
import 'package:chef_king/domain/repositories/home/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _apiClient;

  HomeRepositoryImpl(this._apiClient);

  @override
  Future<DashboardResponse> getDashboard() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.dashboardEndpoint);
      if (response.statusCode == 200) {
        return DashboardResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load dashboard');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> punchIn({required double lat, required double lng}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.punchInEndpoint,
        data: {
          'latitude': lat,
          'longitude': lng,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> punchOut({required double lat, required double lng}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.punchOutEndpoint,
        data: {
          'latitude': lat,
          'longitude': lng,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DutiesResponse> getDuties({int page = 1}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.dutiesEndpoint,
        queryParameters: {'page': page},
      );
      if (response.statusCode == 200) {
        return DutiesResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load duties');
      }
    } catch (e) {
      rethrow;
    }
  }
}
