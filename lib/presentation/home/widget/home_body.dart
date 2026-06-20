import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/data/models/home/dashboard_response.dart';

class HomeBody extends StatelessWidget {
  final HomeState state;

  const HomeBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final data = state.dashboardData?.data;
    return Column(
      children: [
        _buildHeader(context, data),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(LoadHomeData());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickActions(context, data?.todayDuty),
                  const SizedBox(height: 24),
                  _buildRecentActivity(context, data),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, DashboardData? data) {
    final duty = data?.todayDuty;
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 8,
        16,
        16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.primaryBlue,
            backgroundImage: duty?.clients?.profile != null
                ? NetworkImage(duty!.clients!.profile!)
                : null,
            child: duty?.clients?.profile == null
                ? const Icon(Icons.person, color: Colors.white, size: 30)
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CKText(
                duty?.clients?.name ?? "Guard",
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CKText(
                "ID: #${duty?.guardId ?? 'N/A'} • ${duty?.startDate ?? ''}",
                style: context.textTheme.titleMedium?.copyWith(
                  color: AppColors.subTitleTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, TodayDuty? duty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CKText(
              "Today's Duty",
              style: context.textTheme.titleMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            if (duty != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.greenC20PerColor,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.greenColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    CKText(
                      "Ongoing".toUpperCase(),
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppColors.greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.buttonColor, width: 1),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.buttonColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CKText(
                duty?.dutys?.title ?? "No Duty Assigned",
                style: context.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              CKText(
                duty?.dutys?.company ?? "",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const Divider(color: Colors.white24, height: 24),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CKText(
                      duty?.locationes?.siteName ?? "N/A",
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  CKText(
                    "${duty?.dutys?.averageHourPerDay ?? 0} Hours/Day",
                    style: context.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (duty?.locationes?.siteInstruction != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.buttonColor, width: 1),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.buttonColor.withOpacity(0.6),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CKText(
                        "Site Instruction",
                        style: context.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CKText(
                        duty!.locationes!.siteInstruction!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (duty != null) ...[
          const SizedBox(height: 24),
          _buildPunchButton(context, duty),
        ],
      ],
    );
  }

  Widget _buildPunchButton(BuildContext context, TodayDuty? duty) {
    // Determine the attendance directly from the state which was passed at the top.
    final data = state.dashboardData?.data;
    if (duty == null || data == null) return const SizedBox();

    final attendance = data.attendanceToday;
    bool isPunchedIn = false;
    bool isPunchedOut = false;

    if (attendance != null) {
      if (attendance is Map) {
        isPunchedIn = attendance['start_time'] != null && attendance['end_time'] == null;
        isPunchedOut = attendance['end_time'] != null;
      } else {
        isPunchedIn = true;
      }
    }

    String buttonText = "Punch In";
    VoidCallback? onPressed;
    Color buttonColor = AppColors.primaryBlue;

    if (isPunchedOut) {
      buttonText = "Duty Completed";
      onPressed = null;
      buttonColor = Colors.grey;
    } else if (isPunchedIn) {
      buttonText = "Punch Out";
      onPressed = () => context.read<HomeBloc>().add(PunchOutRequested());
      buttonColor = Colors.redAccent;
    } else {
      buttonText = "Punch In";
      onPressed = () => _showLocationPrompt(context);
      buttonColor = AppColors.primaryBlue;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: state.isPunching ? null : onPressed,
        child: state.isPunching
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : CKText(
                buttonText,
                style: context.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, DashboardData? data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CKText(
          "Quick Overview",
          style: context.textTheme.titleMedium?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildGridItem(
              context,
              "Attendance Status",
              data?.attendanceToday != null ? "Present Today" : "Not Marked Yet",
              AppAssets.attendanceStatusIcon,
            ),
            _buildGridItem(
              context,
              "Payroll Summary",
              "View Details",
              AppAssets.payrollSummaryIcon,
            ),
            _buildGridItem(
              context,
              "Pending Leaves",
              "${data?.pendingLeavesCount ?? 0} Pending",
              AppAssets.pendingLeavesIcon,
              onTap: () => context.read<MainBloc>().add(TabChanged(2)),
            ),
            _buildGridItem(
              context,
              "Latest Notice",
              data?.latestNotices?.isNotEmpty == true
                  ? data!.latestNotices![0].title ?? "New Notice"
                  : "No Notices",
              AppAssets.latestNoticeIcon,
            ),
            _buildGridItem(
              context,
              "Incident Reporting",
              "Report On-site Issues",
              AppAssets.reportIcon,
              onTap: () => context.read<MainBloc>().add(TabChanged(3)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    String title,
    String subtitle,
    String iconPath, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.buttonColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: 32, height: 32),
            const SizedBox(height: 12),
            CKText(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            CKText(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.subTitleTextColor,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationPrompt(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: AppColors.buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, color: AppColors.primaryBlue, size: 64),
              const SizedBox(height: 16),
              CKText(
                "GPS Location Required",
                style: context.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              CKText(
                "To ensure accurate attendance reporting, please click below to start location services for your punch-in.",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const CKText("Cancel", style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<HomeBloc>().add(PunchInRequested());
                      },
                      child: const CKText("Start", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
