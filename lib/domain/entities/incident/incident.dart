import 'package:equatable/equatable.dart';

class Incident extends Equatable {
  final int? id;
  final String? incidentNo;
  final String? name;
  final String? reason;
  final String? place;
  final String? dateTime;
  final String? photos;
  final String? clientName;
  final String? locationName;

  const Incident({
    this.id,
    this.incidentNo,
    this.name,
    this.reason,
    this.place,
    this.dateTime,
    this.photos,
    this.clientName,
    this.locationName,
  });

  @override
  List<Object?> get props => [
    id,
    incidentNo,
    name,
    reason,
    place,
    dateTime,
    photos,
    clientName,
    locationName,
  ];
}
