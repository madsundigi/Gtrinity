import 'package:chef_king/core/imports/app_imports.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainState()) {
    on<TabChanged>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });

    on<ResetTab>((event, emit) {
      emit(const MainState(selectedIndex: 0));
    });
  }
}
