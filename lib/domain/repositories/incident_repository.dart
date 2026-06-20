import 'package:chef_king/domain/entities/incident/incident.dart';
import 'dart:io';

abstract class IncidentRepository {
  Future<List<Incident>> getIncidents();
  Future<bool> reportIncident({
    required String name,
    required String reason,
    required String place,
    File? photo,
  });
}
