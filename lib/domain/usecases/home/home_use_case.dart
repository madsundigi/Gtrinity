import 'package:chef_king/data/models/duties/duties_response.dart';
import 'package:chef_king/data/models/home/dashboard_response.dart';
import 'package:chef_king/domain/repositories/home/home_repository.dart';

class HomeUseCase {
  final HomeRepository _repository;

  HomeUseCase(this._repository);

  Future<DashboardResponse> execute() {
    return _repository.getDashboard();
  }

  Future<Map<String, dynamic>> punchIn({required double lat, required double lng}) {
    return _repository.punchIn(lat: lat, lng: lng);
  }

  Future<Map<String, dynamic>> punchOut({required double lat, required double lng}) {
    return _repository.punchOut(lat: lat, lng: lng);
  }

  Future<DutiesResponse> getDuties({int page = 1}) {
    return _repository.getDuties(page: page);
  }
}
