import 'dart:io';
import 'package:chef_king/domain/entities/document/guard_document.dart';

abstract class DocumentRepository {
  Future<List<GuardDocument>> getDocuments();
  Future<bool> uploadDocument({
    required String name,
    required File file,
  });
}
