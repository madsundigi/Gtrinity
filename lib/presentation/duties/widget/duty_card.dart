import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/data/models/home/dashboard_response.dart';

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
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, TodayDuty duty) {
    // Basic logic to determine if duty is today
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final isToday = duty.startDate?.startsWith(todayStr) ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isToday ? AppColors.greenC20PerColor : Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: CKText(
        isToday ? "TODAY" : "SCHEDULED",
        style: context.textTheme.titleSmall?.copyWith(
          color: isToday ? AppColors.greenColor : AppColors.subTitleTextColor,
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
