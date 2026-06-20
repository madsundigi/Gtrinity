import 'package:chef_king/data/local/app_cache/app_cache.dart';
import 'package:chef_king/domain/usecases/auth/AuthUseCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthUseCase authUseCase;

  ProfileBloc({required this.authUseCase}) : super(const ProfileState()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<LogoutRequested>(_onLogoutRequested);
    on<ClearLogoutState>(_onClearLogoutState);
  }

  Future<void> _onLoadProfileData(
    LoadProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    // Reset logout success when loading profile data
    emit(state.copyWith(isLoading: true, isLogoutSuccess: false));
    
    final loginResponse = AppCache.getLoginResponse();
    final user = loginResponse?.data?.user;
    
    if (user != null) {
      emit(state.copyWith(
        isLoading: false,
        user: user,
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'User data not found',
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final success = await authUseCase.logout();
      if (success) {
        await AppCache.clear();
        emit(state.copyWith(isLoading: false, isLogoutSuccess: true));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to logout from server',
        ));
      }
    } catch (e) {
      // Even if API fails, we should probably clear local cache and logout
      await AppCache.clear();
      emit(state.copyWith(
        isLoading: false,
        isLogoutSuccess: true,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onClearLogoutState(
    ClearLogoutState event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(isLogoutSuccess: false));
  }
}
