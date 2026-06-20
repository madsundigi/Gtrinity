import 'package:chef_king/domain/entities/leave/leave_application.dart';

class LeaveModel extends LeaveApplication {
  const LeaveModel({
    super.id,
    super.startDate,
    super.endDate,
    super.reason,
    super.status,
    super.appliedDate,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      reason: json['reason'],
      status: json['status'],
      appliedDate: json['created_at'],
    );
  }

  static List<LeaveModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => LeaveModel.fromJson(item)).toList();
  }
}
