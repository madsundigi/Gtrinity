import 'dart:io';
import 'package:chef_king/core/di/injection.dart';
import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/presentation/documents/cubit/document_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _selectedFile;
  String? _fileName;

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DocumentCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          centerTitle: true,
          title: const CKText(
            'Upload Document',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<DocumentCubit, DocumentState>(
          listener: (context, state) {
            if (state is DocumentUploaded) {
              CKSnackBar.showSuccess(context, 'Document uploaded successfully');
              Navigator.pop(context, true);
            } else if (state is DocumentError) {
              CKSnackBar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CKText('DOCUMENT INFO', style: TextStyle(color: AppColors.subTitleTextColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    const SizedBox(height: 16),
                    CKInputField(
                      controller: _nameController,
                      hintText: 'e.g. License, ID Proof, Certification',
                      labelText: 'Document Name',
                    ),
                    const SizedBox(height: 24),
                    const CKText('SELECT FILE', style: TextStyle(color: AppColors.subTitleTextColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _pickDocument,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _selectedFile == null ? Icons.attach_file : Icons.check_circle,
                              size: 40,
                              color: _selectedFile == null ? AppColors.primaryBlue : AppColors.greenColor,
                            ),
                            const SizedBox(height: 12),
                            CKText(
                              _fileName ?? 'Tap to select PDF or Image',
                              style: TextStyle(
                                color: _selectedFile == null ? AppColors.subTitleTextColor : Colors.white,
                                fontSize: 13,
                                fontWeight: _selectedFile == null ? FontWeight.normal : FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    CKButton(
                      onPressed: state is DocumentUploading ? null : () {
                        if (_formKey.currentState!.validate()){
                          if (_selectedFile == null) {
                            CKSnackBar.showError(context, 'Please select a file to upload');
                            return;
                          }
                          context.read<DocumentCubit>().uploadDocument(
                            name: _nameController.text,
                            file: _selectedFile!,
                          );
                        }
                      },
                      label: state is DocumentUploading ? 'UPLOADING...' : 'SUBMIT DOCUMENT',
                      color: AppColors.primaryBlue,
                      isLoading: state is DocumentUploading,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
