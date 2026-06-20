import 'package:chef_king/domain/entities/leave/leave_application.dart';
import 'package:chef_king/domain/repositories/leave_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LeaveState extends Equatable {
  const LeaveState();
  @override
  List<Object?> get props => [];
}

class LeaveInitial extends LeaveState {}
class LeaveLoading extends LeaveState {}
class LeavesLoaded extends LeaveState {
  final List<LeaveApplication> leaves;
  const LeavesLoaded(this.leaves);
  @override
  List<Object?> get props => [leaves];
}
class LeaveError extends LeaveState {
  final String message;
  const LeaveError(this.message);
  @override
  List<Object?> get props => [message];
}

class LeaveApplying extends LeaveState {}
class LeaveApplied extends LeaveState {}

class LeaveCubit extends Cubit<LeaveState> {
  final LeaveRepository repository;

  LeaveCubit({required this.repository}) : super(LeaveInitial());

  Future<void> fetchLeaves() async {
    emit(LeaveLoading());
    try {
      final leaves = await repository.getLeaves();
      emit(LeavesLoaded(leaves));
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }

  Future<void> applyLeave({
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    emit(LeaveApplying());
    try {
      final success = await repository.applyLeave(
        startDate: startDate,
        endDate: endDate,
        reason: reason,
      );
      if (success) {
        emit(LeaveApplied());
        fetchLeaves();
      } else {
        emit(const LeaveError('Failed to apply for leave'));
      }
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }
}
