import 'package:chef_king/core/di/injection.dart';
import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/presentation/leave/cubit/leave_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: (_startDate != null && _endDate != null)
        ? DateTimeRange(start: _startDate!, end: _endDate!)
        : null,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              surface: AppColors.buttonColor,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppColors.darkBackground,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LeaveCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          centerTitle: true,
          title: const CKText(
            'Apply for Leave',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<LeaveCubit, LeaveState>(
          listener: (context, state) {
            if (state is LeaveApplied) {
              CKSnackBar.show(context, message: 'Leave application submitted successfully', type: SnackBarType.success);
              Navigator.pop(context, true);
            } else if (state is LeaveError) {
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
                    const CKText('LEAVE DURATION', style: TextStyle(color: AppColors.subTitleTextColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectDateRange(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CKText(
                              (_startDate == null || _endDate == null)
                                ? 'Select Date Range'
                                : '${DateFormat('dd MMM').format(_startDate!)} - ${DateFormat('dd MMM yyyy').format(_endDate!)}',
                              style: TextStyle(
                                fontSize: 15,
                                color: (_startDate == null) ? AppColors.hintTextColor : Colors.white,
                              ),
                            ),
                            const Icon(Icons.date_range_outlined, color: AppColors.primaryBlue),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const CKText('REASON', style: TextStyle(color: AppColors.subTitleTextColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    const SizedBox(height: 16),
                    CKInputField(
                      controller: _reasonController,
                      hintText: 'e.g. Personal work, Sick, Family function',
                      labelText: 'Reason for Leave',
                    ),
                    const SizedBox(height: 48),
                    CKButton(
                      onPressed: state is LeaveApplying ? null : () {
                        if (_formKey.currentState!.validate()){
                          if (_startDate == null || _endDate == null) {
                            CKSnackBar.show(context, message: 'Please select leave dates', type: SnackBarType.warning);
                            return;
                          }
                          context.read<LeaveCubit>().applyLeave(
                            startDate: _startDate!,
                            endDate: _endDate!,
                            reason: _reasonController.text,
                          );
                        }
                      },
                      label: state is LeaveApplying ? 'SUBMITTING...' : 'SUBMIT APPLICATION',
                      color: Colors.tealAccent.shade700,
                      isLoading: state is LeaveApplying,
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
    _reasonController.dispose();
    super.dispose();
  }
}
