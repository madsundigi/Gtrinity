import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class TabChanged extends MainEvent {
  final int index;

  const TabChanged(this.index);

  @override
  List<Object> get props => [index];
}

class ResetTab extends MainEvent {}
