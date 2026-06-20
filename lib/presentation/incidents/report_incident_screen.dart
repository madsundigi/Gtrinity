import 'dart:io';
import 'package:chef_king/core/di/injection.dart';
import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/presentation/incidents/cubit/incidents_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reasonController = TextEditingController();
  final _placeController = TextEditingController();
  File? _image;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<IncidentsCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          centerTitle: true,
          title: const CKText(
            'Report Incident',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<IncidentsCubit, IncidentsState>(
          listener: (context, state) {
            if (state is IncidentReported) {
              CKSnackBar.show(context, message: 'Incident reported successfully', type: SnackBarType.success);
              Navigator.pop(context, true);
            } else if (state is IncidentsError) {
              CKSnackBar.show(context, message: 'Error: ${state.message}', type: SnackBarType.error);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CKText('INCIDENT DETAILS', style: TextStyle(color: AppColors.subTitleTextColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    const SizedBox(height: 16),
                    CKInputField(
                      controller: _nameController,
                      hintText: 'e.g. Fire, Theft, Unusual Activity',
                      labelText: 'Incident Title',
                    ),
                    const SizedBox(height: 16),
                    CKInputField(
                      controller: _reasonController,
                      hintText: 'Give more details about the incident',
                      labelText: 'Description / Reason',
                    ),
                    const SizedBox(height: 16),
                    CKInputField(
                      controller: _placeController,
                      hintText: 'Where on-site did this happen?',
                      labelText: 'Occurred Place',
                    ),
                    const SizedBox(height: 24),
                    const CKText('EVIDENCE', style: TextStyle(color: AppColors.subTitleTextColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    const SizedBox(height: 12),
                    _image == null
                      ? InkWell(
                          onTap: _pickImage,
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, size: 40, color: AppColors.primaryBlue),
                                SizedBox(height: 8),
                                CKText('Tap to capture photo', style: TextStyle(color: AppColors.subTitleTextColor, fontSize: 13)),
                              ],
                            ),
                          ),
                        )
                      : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_image!, height: 220, width: double.infinity, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => setState(() => _image = null),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                    const SizedBox(height: 40),
                    CKButton(
                      onPressed: state is IncidentsReporting ? null : () {
                        if (_formKey.currentState!.validate()) {
                          context.read<IncidentsCubit>().reportIncident(
                            name: _nameController.text,
                            reason: _reasonController.text,
                            place: _placeController.text,
                            photo: _image,
                          );
                        }
                      },
                      label: state is IncidentsReporting ? 'SUBMITTING...' : 'SUBMIT REPORT',
                      color: AppColors.primaryBlue,
                      isLoading: state is IncidentsReporting,
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
    _reasonController.dispose();
    _placeController.dispose();
    super.dispose();
  }
}
