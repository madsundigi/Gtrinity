import 'package:equatable/equatable.dart';

class LeaveApplication extends Equatable {
  final int? id;
  final String? startDate;
  final String? endDate;
  final String? reason;
  final String? status;
  final String? appliedDate;

  const LeaveApplication({
    this.id,
    this.startDate,
    this.endDate,
    this.reason,
    this.status,
    this.appliedDate,
  });

  @override
  List<Object?> get props => [
    id,
    startDate,
    endDate,
    reason,
    status,
    appliedDate,
  ];
}
