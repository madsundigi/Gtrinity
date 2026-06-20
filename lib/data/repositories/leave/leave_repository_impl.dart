import 'package:chef_king/core/constants/api_constants.dart';
import 'package:chef_king/data/models/leave/leave_model.dart';
import 'package:chef_king/domain/entities/leave/leave_application.dart';
import 'package:chef_king/domain/repositories/leave_repository.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final Dio dio;

  LeaveRepositoryImpl({required this.dio});

  @override
  Future<List<LeaveApplication>> getLeaves() async {
    try {
      final response = await dio.get(ApiConstants.leavesEndpoint);
      if (response.data['success'] == true) {
        final List<dynamic> list = response.data['data']['data'];
        return LeaveModel.fromJsonList(list);
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> applyLeave({
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.applyLeaveEndpoint,
        data: {
          'start_date': DateFormat('yyyy-MM-dd').format(startDate),
          'end_date': DateFormat('yyyy-MM-dd').format(endDate),
          'reason': reason,
        },
      );
      return response.data['success'] == true;
    } catch (e) {
      rethrow;
    }
  }
}
