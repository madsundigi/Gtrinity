import 'dart:io';
import 'package:chef_king/domain/entities/incident/incident.dart';
import 'package:chef_king/domain/repositories/incident_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class IncidentsState extends Equatable {
  const IncidentsState();
  @override
  List<Object?> get props => [];
}

class IncidentsInitial extends IncidentsState {}
class IncidentsLoading extends IncidentsState {}
class IncidentsLoaded extends IncidentsState {
  final List<Incident> incidents;
  const IncidentsLoaded(this.incidents);
  @override
  List<Object?> get props => [incidents];
}
class IncidentsError extends IncidentsState {
  final String message;
  const IncidentsError(this.message);
  @override
  List<Object?> get props => [message];
}

class IncidentsReporting extends IncidentsState {}
class IncidentReported extends IncidentsState {}

class IncidentsCubit extends Cubit<IncidentsState> {
  final IncidentRepository repository;

  IncidentsCubit({required this.repository}) : super(IncidentsInitial());

  Future<void> fetchIncidents() async {
    emit(IncidentsLoading());
    try {
      final incidents = await repository.getIncidents();
      emit(IncidentsLoaded(incidents));
    } catch (e) {
      emit(IncidentsError(e.toString()));
    }
  }

  Future<void> reportIncident({
    required String name,
    required String reason,
    required String place,
    File? photo,
  }) async {
    emit(IncidentsReporting());
    try {
      final success = await repository.reportIncident(
        name: name,
        reason: reason,
        place: place,
        photo: photo,
      );
      if (success) {
        emit(IncidentReported());
        fetchIncidents();
      } else {
        emit(const IncidentsError('Failed to report incident'));
      }
    } catch (e) {
      emit(IncidentsError(e.toString()));
    }
  }
}
