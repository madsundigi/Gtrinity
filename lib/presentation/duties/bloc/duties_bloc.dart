import 'package:chef_king/domain/usecases/home/home_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'duties_event.dart';
import 'duties_state.dart';

class DutiesBloc extends Bloc<DutiesEvent, DutiesState> {
  final HomeUseCase homeUseCase;

  DutiesBloc({required this.homeUseCase}) : super(const DutiesState()) {
    on<LoadDuties>(_onLoadDuties);
    on<LoadMoreDuties>(_onLoadMoreDuties);
  }

  Future<void> _onLoadDuties(
    LoadDuties event,
    Emitter<DutiesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final response = await homeUseCase.getDuties(page: event.page);
      if (response.success == true) {
        emit(state.copyWith(
          isLoading: false,
          dutiesData: response,
          duties: response.data?.data ?? [],
          currentPage: response.data?.currentPage ?? 1,
          hasReachedMax: response.data?.currentPage == response.data?.lastPage,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to fetch duties data',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreDuties(
    LoadMoreDuties event,
    Emitter<DutiesState> emit,
  ) async {
    if (state.hasReachedMax || state.isMoreLoading) return;

    emit(state.copyWith(isMoreLoading: true));
    try {
      final nextPage = state.currentPage + 1;
      final response = await homeUseCase.getDuties(page: nextPage);
      if (response.success == true) {
        final newDuties = response.data?.data ?? [];
        emit(state.copyWith(
          isMoreLoading: false,
          duties: List.from(state.duties)..addAll(newDuties),
          currentPage: response.data?.currentPage ?? nextPage,
          hasReachedMax: response.data?.currentPage == response.data?.lastPage,
        ));
      } else {
        emit(state.copyWith(
          isMoreLoading: false,
          errorMessage: 'Failed to fetch more duties',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isMoreLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
