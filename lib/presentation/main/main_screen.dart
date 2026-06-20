import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/presentation/profile/profile_screen.dart';
import 'package:chef_king/presentation/duties/duties_screen.dart';
import 'package:chef_king/presentation/duties/bloc/duties_bloc.dart';
import 'package:chef_king/presentation/incidents/incident_screen.dart';
import 'package:chef_king/presentation/leave/leave_screen.dart';

class MainScreen extends CKBaseScreen<MainBloc, MainState> {
  const MainScreen({super.key});
  @override
  Widget buildBody(BuildContext context, MainState state) {
    return IndexedStack(
      index: state.selectedIndex,
      children: [
        const HomeScreen(),
        BlocProvider(
          create: (context) => sl<DutiesBloc>(),
          child: const DutiesScreen(),
        ),
        const LeaveScreen(),
        const IncidentScreen(),
        const ProfileScreen(),
      ],
    );
  }

  @override
  Widget? buildBottomNavigationBar(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<MainBloc>().add(TabChanged(index));
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.buttonColor,
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.subTitleTextColor,
            selectedLabelStyle: const TextStyle(fontSize: 10),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.homeIcon,
                  colorFilter: ColorFilter.mode(
                    state.selectedIndex == 0
                        ? AppColors.white
                        : AppColors.subTitleTextColor,
                    BlendMode.srcIn,
                  ),
                ),
                label: AppStrings.home,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.dutiesIcon,
                  colorFilter: ColorFilter.mode(
                    state.selectedIndex == 1
                        ? AppColors.white
                        : AppColors.subTitleTextColor,
                    BlendMode.srcIn,
                  ),
                ),
                label: AppStrings.duties,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.attendanceIcon,
                  colorFilter: ColorFilter.mode(
                    state.selectedIndex == 2
                        ? AppColors.white
                        : AppColors.subTitleTextColor,
                    BlendMode.srcIn,
                  ),
                ),
                label: AppStrings.attendance,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.reportIcon,
                  colorFilter: ColorFilter.mode(
                    state.selectedIndex == 3
                        ? AppColors.white
                        : AppColors.subTitleTextColor,
                    BlendMode.srcIn,
                  ),
                ),
                label: AppStrings.report,
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.profileIcon,
                  colorFilter: ColorFilter.mode(
                    state.selectedIndex == 4
                        ? AppColors.white
                        : AppColors.subTitleTextColor,
                    BlendMode.srcIn,
                  ),
                ),
                label: AppStrings.profile,
              ),
            ],
          ),
        );
      },
    );
  }
}
