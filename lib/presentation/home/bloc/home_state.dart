import 'package:chef_king/data/models/home/dashboard_response.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final bool isPunching;
  final String? errorMessage;
  final String? attendanceMessage;
  final DashboardResponse? dashboardData;

  const HomeState({
    this.isLoading = false,
    this.isPunching = false,
    this.errorMessage,
    this.attendanceMessage,
    this.dashboardData,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? isPunching,
    String? errorMessage,
    String? attendanceMessage,
    DashboardResponse? dashboardData,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isPunching: isPunching ?? this.isPunching,
      errorMessage: errorMessage ?? this.errorMessage,
      attendanceMessage: attendanceMessage ?? this.attendanceMessage,
      dashboardData: dashboardData ?? this.dashboardData,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isPunching,
        errorMessage,
        attendanceMessage,
        dashboardData,
      ];
}
