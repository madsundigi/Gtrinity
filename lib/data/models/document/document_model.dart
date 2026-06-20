import 'package:chef_king/domain/entities/document/guard_document.dart';

class DocumentModel extends GuardDocument {
  const DocumentModel({
    super.id,
    super.name,
    super.filePath,
    super.uploadDate,
    super.status,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      filePath: json['file_path']?.toString(),
      uploadDate: json['upload_date']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'file_path': filePath,
      'upload_date': uploadDate,
      'status': status,
    };
  }

  static List<DocumentModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => DocumentModel.fromJson(json)).toList();
  }
}
