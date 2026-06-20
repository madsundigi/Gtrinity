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
