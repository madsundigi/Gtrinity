import 'package:chef_king/data/models/duties/duties_response.dart';
import 'package:chef_king/data/models/home/dashboard_response.dart';

abstract class HomeRepository {
  Future<DashboardResponse> getDashboard();
  Future<Map<String, dynamic>> punchIn({required double lat, required double lng});
  Future<Map<String, dynamic>> punchOut({required double lat, required double lng});
  Future<DutiesResponse> getDuties({int page = 1});
  Future<Map<String, dynamic>> acceptDuty(int id);
  Future<Map<String, dynamic>> rejectDuty(int id);
}
