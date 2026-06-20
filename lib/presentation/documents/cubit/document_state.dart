part of 'document_cubit.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentUploading extends DocumentState {}

class DocumentUploaded extends DocumentState {}

class DocumentsLoaded extends DocumentState {
  final List<GuardDocument> documents;

  const DocumentsLoaded({required this.documents});

  @override
  List<Object?> get props => [documents];
}

class DocumentError extends DocumentState {
  final String message;

  const DocumentError({required this.message});

  @override
  List<Object?> get props => [message];
}
