import 'dart:io';
import 'package:chef_king/core/constants/api_constants.dart';
import 'package:chef_king/data/models/incident/incident_model.dart';
import 'package:chef_king/domain/entities/incident/incident.dart';
import 'package:chef_king/domain/repositories/incident_repository.dart';
import 'package:dio/dio.dart';

class IncidentRepositoryImpl implements IncidentRepository {
  final Dio dio;

  IncidentRepositoryImpl({required this.dio});

  @override
  Future<List<Incident>> getIncidents() async {
    try {
      final response = await dio.get(ApiConstants.incidentsEndpoint);
      if (response.data['success'] == true) {
        final List<dynamic> list = response.data['data']['data'];
        return IncidentModel.fromJsonList(list);
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> reportIncident({
    required String name,
    required String reason,
    required String place,
    File? photo,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'incident_occurred_reason': reason,
        'incident_occurred_place': place,
      });

      if (photo != null) {
        formData.files.add(MapEntry(
          'photo',
          await MultipartFile.fromFile(photo.path, filename: photo.path.split('/').last),
        ));
      }

      final response = await dio.post(ApiConstants.incidentsEndpoint, data: formData);
      return response.data['success'] == true;
    } catch (e) {
      rethrow;
    }
  }
}
