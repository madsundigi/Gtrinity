import 'package:chef_king/core/di/injection.dart';
import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/presentation/documents/cubit/document_cubit.dart';
import 'package:chef_king/presentation/documents/upload_document_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DocumentCubit>()..fetchDocuments(),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          centerTitle: true,
          title: const CKText(
            'My Documents',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<DocumentCubit, DocumentState>(
          builder: (context, state) {
            if (state is DocumentLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
            } else if (state is DocumentsLoaded) {
              if (state.documents.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open_outlined, size: 64, color: AppColors.subTitleTextColor.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      const CKText('No documents uploaded yet.', style: TextStyle(color: AppColors.subTitleTextColor)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.documents.length,
                itemBuilder: (context, index) {
                  final doc = state.documents[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.buttonColor, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            doc.filePath?.endsWith('.pdf') == true ? Icons.picture_as_pdf : Icons.image,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CKText(
                                doc.name ?? 'Untitled Document',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              CKText(
                                'Uploaded: ${DateFormat('dd MMM yyyy').format(DateTime.parse(doc.uploadDate!))}',
                                style: const TextStyle(color: AppColors.subTitleTextColor, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        _buildStatusBadge(doc.status),
                      ],
                    ),
                  );
                },
              );
            } else if (state is DocumentError) {
              return Center(child: CKText('Error: ${state.message}', style: const TextStyle(color: Colors.redAccent)));
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadDocumentScreen()),
            );
            if (result == true) {
              // Refresh is handled by fetchDocuments in Uploaded state
            }
          },
          backgroundColor: AppColors.primaryBlue,
          label: const CKText('UPLOAD NEW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          icon: const Icon(Icons.upload_file, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color;
    switch (status?.toLowerCase()) {
      case 'verified': color = AppColors.greenColor; break;
      case 'pending': color = Colors.orangeAccent; break;
      case 'rejected': color = Colors.redAccent; break;
      default: color = AppColors.primaryBlue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: CKText(
        status?.toUpperCase() ?? 'PENDING',
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}
