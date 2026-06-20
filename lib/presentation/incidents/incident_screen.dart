import 'package:chef_king/core/di/injection.dart';
import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/presentation/incidents/cubit/incidents_cubit.dart';
import 'package:chef_king/presentation/incidents/report_incident_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class IncidentScreen extends StatelessWidget {
  const IncidentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<IncidentsCubit>()..fetchIncidents(),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          centerTitle: true,
          title: const CKText(
            'Incident Reports',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<IncidentsCubit, IncidentsState>(
          builder: (context, state) {
            if (state is IncidentsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
            } else if (state is IncidentsLoaded) {
              if (state.incidents.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_late_outlined, size: 64, color: AppColors.subTitleTextColor.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      const CKText('No incidents reported yet.', style: TextStyle(color: AppColors.subTitleTextColor)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.incidents.length,
                itemBuilder: (context, index) {
                  final incident = state.incidents[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.buttonColor, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CKText(
                                incident.name ?? 'Unknown Incident',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (incident.photos != null)
                              const Icon(Icons.image, color: AppColors.primaryBlue, size: 20),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CKText(
                          incident.reason ?? '',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const Divider(color: Colors.white12, height: 24),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppColors.subTitleTextColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: CKText(
                                incident.place ?? 'On-site',
                                style: const TextStyle(fontSize: 12, color: AppColors.subTitleTextColor),
                              ),
                            ),
                            CKText(
                              DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(incident.dateTime ?? DateTime.now().toString())),
                              style: const TextStyle(fontSize: 11, color: AppColors.primaryBlue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is IncidentsError) {
              return Center(child: CKText('Error: ${state.message}', style: const TextStyle(color: Colors.redAccent)));
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportIncidentScreen()),
            );
            if (result == true) {
              // Refresh is handled by Cubit emit(IncidentReported) -> fetchIncidents
            }
          },
          backgroundColor: AppColors.primaryBlue,
          label: const CKText('Report Incident', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
