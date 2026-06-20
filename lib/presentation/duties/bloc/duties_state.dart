import 'package:chef_king/data/models/duties/duties_response.dart';
import 'package:equatable/equatable.dart';

class DutiesState extends Equatable {
  final bool isLoading;
  final bool isMoreLoading;
  final String? errorMessage;
  final DutiesResponse? dutiesData;
  final List<dynamic> duties;
  final int currentPage;
  final bool hasReachedMax;

  const DutiesState({
    this.isLoading = false,
    this.isMoreLoading = false,
    this.errorMessage,
    this.dutiesData,
    this.duties = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  DutiesState copyWith({
    bool? isLoading,
    bool? isMoreLoading,
    String? errorMessage,
    DutiesResponse? dutiesData,
    List<dynamic>? duties,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return DutiesState(
      isLoading: isLoading ?? this.isLoading,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      dutiesData: dutiesData ?? this.dutiesData,
      duties: duties ?? this.duties,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isMoreLoading,
        errorMessage,
        dutiesData,
        duties,
        currentPage,
        hasReachedMax,
      ];
}
