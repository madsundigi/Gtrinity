import 'package:chef_king/domain/entities/leave/leave_application.dart';

abstract class LeaveRepository {
  Future<List<LeaveApplication>> getLeaves();
  Future<bool> applyLeave({
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  });
}
