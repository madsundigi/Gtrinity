import 'package:equatable/equatable.dart';

abstract class DutiesEvent extends Equatable {
  const DutiesEvent();

  @override
  List<Object?> get props => [];
}

class LoadDuties extends DutiesEvent {
  final int page;
  const LoadDuties({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class LoadMoreDuties extends DutiesEvent {}

/// Guard accepts (accept = true) or rejects (accept = false) an assigned shift.
class RespondToDuty extends DutiesEvent {
  final int dutyId;
  final bool accept;
  const RespondToDuty({required this.dutyId, required this.accept});

  @override
  List<Object?> get props => [dutyId, accept];
}
