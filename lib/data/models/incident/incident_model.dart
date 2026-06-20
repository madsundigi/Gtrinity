import 'package:chef_king/domain/entities/incident/incident.dart';

class IncidentModel extends Incident {
  const IncidentModel({
    super.id,
    super.incidentNo,
    super.name,
    super.reason,
    super.place,
    super.dateTime,
    super.photos,
    super.clientName,
    super.locationName,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'],
      incidentNo: json['incident_no']?.toString(),
      name: json['name'],
      reason: json['incident_occurred_reason'],
      place: json['incident_occurred_place'],
      dateTime: json['date_time'],
      photos: json['incident_photos'],
      clientName: json['clients']?['name'],
      locationName: json['incident_location']?.toString(),
    );
  }

  static List<IncidentModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => IncidentModel.fromJson(item)).toList();
  }
}
