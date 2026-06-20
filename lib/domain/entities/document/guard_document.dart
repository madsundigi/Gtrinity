import 'package:equatable/equatable.dart';

class GuardDocument extends Equatable {
  final String? id;
  final String? name;
  final String? filePath;
  final String? uploadDate;
  final String? status;

  const GuardDocument({
    this.id,
    this.name,
    this.filePath,
    this.uploadDate,
    this.status,
  });

  @override
  List<Object?> get props => [id, name, filePath, uploadDate, status];
}
