import 'package:chef_king/core/imports/app_imports.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(Initial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(Loading());
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (AppCache.isLoggedIn()) {
      emit(NavigateToMain());
    } else {
      emit(NavigateToLogin());
    }
  }
}
