import 'dart:io';
import 'package:chef_king/core/constants/api_constants.dart';
import 'package:chef_king/data/models/document/document_model.dart';
import 'package:chef_king/domain/entities/document/guard_document.dart';
import 'package:chef_king/domain/repositories/document_repository.dart';
import 'package:dio/dio.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final Dio dio;

  DocumentRepositoryImpl({required this.dio});

  @override
  Future<List<GuardDocument>> getDocuments() async {
    try {
      final response = await dio.get(ApiConstants.documentsEndpoint);
      if (response.data['success'] == true) {
        final List<dynamic> list = response.data['data'];
        return DocumentModel.fromJsonList(list);
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> uploadDocument({
    required String name,
    required File file,
  }) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'name': name,
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await dio.post(
        ApiConstants.uploadDocumentEndpoint,
        data: formData,
      );
      return response.data['success'] == true;
    } catch (e) {
      rethrow;
    }
  }
}
