import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/data/models/home/dashboard_response.dart';
import 'package:chef_king/presentation/duties/bloc/duties_bloc.dart';
import 'package:chef_king/presentation/duties/bloc/duties_event.dart';

class DutyCard extends StatelessWidget {
  final TodayDuty duty;

  const DutyCard({super.key, required this.duty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.buttonColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.buttonColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.work_outline, color: AppColors.primaryBlue, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CKText(
                      duty.dutys?.title ?? "Security Guard Duty",
                      style: context.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CKText(
                      duty.dutys?.company ?? "Guard Service",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.subTitleTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(context, duty),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 16),
          _buildInfoRow(context, Icons.location_on_outlined, duty.locationes?.siteName ?? "Client Location"),
          const SizedBox(height: 10),
          _buildInfoRow(context, Icons.calendar_today_outlined, duty.startDate ?? "No Date"),
          const SizedBox(height: 10),
          _buildInfoRow(context, Icons.access_time, "${duty.dutys?.averageHourPerDay ?? 0} Hours Scheduled"),
          if ((duty.status ?? 'pending').toLowerCase() == 'pending') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context
                        .read<DutiesBloc>()
                        .add(RespondToDuty(dutyId: duty.id ?? 0, accept: false)),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context
                        .read<DutiesBloc>()
                        .add(RespondToDuty(dutyId: duty.id ?? 0, accept: true)),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, TodayDuty duty) {
    final status = (duty.status ?? 'pending').toLowerCase();
    Color color;
    String label;
    switch (status) {
      case 'accepted':
        color = AppColors.greenColor;
        label = 'ACCEPTED';
        break;
      case 'rejected':
        color = Colors.redAccent;
        label = 'REJECTED';
        break;
      default:
        color = Colors.orangeAccent;
        label = 'PENDING';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CKText(
        label,
        style: context.textTheme.titleSmall?.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: CKText(
            text,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
