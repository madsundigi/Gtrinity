import 'package:chef_king/core/di/injection.dart';
import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/presentation/leave/apply_leave_screen.dart';
import 'package:chef_king/presentation/leave/cubit/leave_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LeaveCubit>()..fetchLeaves(),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          centerTitle: true,
          title: const CKText(
            'Leave Management',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<LeaveCubit, LeaveState>(
          builder: (context, state) {
            if (state is LeaveLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
            } else if (state is LeavesLoaded) {
              if (state.leaves.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 64, color: AppColors.subTitleTextColor.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      const CKText('No leave applications yet.', style: TextStyle(color: AppColors.subTitleTextColor)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.leaves.length,
                itemBuilder: (context, index) {
                  final leave = state.leaves[index];
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
                            CKText(
                              '${DateFormat('dd MMM').format(DateTime.parse(leave.startDate!))} - ${DateFormat('dd MMM yyyy').format(DateTime.parse(leave.endDate!))}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            _buildStatusChip(leave.status),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CKText(
                          'Reason: ${leave.reason ?? ""}',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const Divider(color: Colors.white12, height: 24),
                        Row(
                          children: [
                            const Icon(Icons.history, size: 14, color: AppColors.subTitleTextColor),
                            const SizedBox(width: 4),
                            CKText(
                              'Applied on: ${DateFormat('dd MMM yyyy').format(DateTime.parse(leave.appliedDate!))}',
                              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.subTitleTextColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is LeaveError) {
              return Center(child: CKText('Error: ${state.message}', style: const TextStyle(color: Colors.redAccent)));
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ApplyLeaveScreen()),
            );
            if (result == true) {
              // Refresh is handled by Cubit emit(LeaveApplied) -> fetchLeaves
            }
          },
          backgroundColor: Colors.tealAccent.shade700,
          label: const CKText('APPLY LEAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          icon: const Icon(Icons.add_task, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    Color color;
    switch (status?.toLowerCase()) {
      case 'approved': color = AppColors.greenColor; break;
      case 'pending': color = Colors.orangeAccent; break;
      case 'rejected': color = Colors.redAccent; break;
      default: color = AppColors.primaryBlue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: CKText(
        status?.toUpperCase() ?? 'PENDING',
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
