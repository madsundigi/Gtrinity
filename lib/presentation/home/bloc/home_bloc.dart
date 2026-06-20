import 'package:chef_king/domain/usecases/home/home_use_case.dart';
import 'package:chef_king/core/services/location_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeUseCase homeUseCase;
  final LocationService locationService;

  HomeBloc({required this.homeUseCase, required this.locationService}) : super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<PunchInRequested>(_onPunchInRequested);
    on<PunchOutRequested>(_onPunchOutRequested);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, attendanceMessage: null));
    try {
      final response = await homeUseCase.execute();
      if (response.success == true) {
        emit(state.copyWith(
          isLoading: false,
          dashboardData: response,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to fetch dashboard data',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPunchInRequested(
    PunchInRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isPunching: true, errorMessage: null, attendanceMessage: null));
    try {
      final position = await locationService.getCurrentPosition();
      if (position != null) {
        final response = await homeUseCase.punchIn(lat: position.latitude, lng: position.longitude);
        emit(state.copyWith(
          isPunching: false,
          attendanceMessage: response['message'] ?? 'Successfully punched in',
        ));
        add(LoadHomeData()); // Refresh dashboard data to reflect new status
      }
    } catch (e) {
      emit(state.copyWith(
        isPunching: false,
        errorMessage: 'Punch in failed: ${e.toString()}',
      ));
    }
  }

  Future<void> _onPunchOutRequested(
    PunchOutRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isPunching: true, errorMessage: null, attendanceMessage: null));
    try {
      final position = await locationService.getCurrentPosition();
      if (position != null) {
        final response = await homeUseCase.punchOut(lat: position.latitude, lng: position.longitude);
        emit(state.copyWith(
          isPunching: false,
          attendanceMessage: response['message'] ?? 'Successfully punched out',
        ));
        add(LoadHomeData()); // Refresh dashboard data to reflect new status
      }
    } catch (e) {
      emit(state.copyWith(
        isPunching: false,
        errorMessage: 'Punch out failed: ${e.toString()}',
      ));
    }
  }
}
