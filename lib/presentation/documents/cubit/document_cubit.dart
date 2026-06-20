import 'dart:io';
import 'package:chef_king/domain/entities/document/guard_document.dart';
import 'package:chef_king/domain/repositories/document_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'document_state.dart';

class DocumentCubit extends Cubit<DocumentState> {
  final DocumentRepository repository;

  DocumentCubit({required this.repository}) : super(DocumentInitial());

  Future<void> fetchDocuments() async {
    emit(DocumentLoading());
    try {
      final documents = await repository.getDocuments();
      emit(DocumentsLoaded(documents: documents));
    } catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }

  Future<void> uploadDocument({
    required String name,
    required File file,
  }) async {
    emit(DocumentUploading());
    try {
      final success = await repository.uploadDocument(name: name, file: file);
      if (success) {
        emit(DocumentUploaded());
        fetchDocuments();
      } else {
        emit(const DocumentError(message: 'Failed to upload document.'));
      }
    } catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }
}
