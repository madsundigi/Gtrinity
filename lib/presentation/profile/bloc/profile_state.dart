import 'package:chef_king/data/models/auth/LoginResponse.dart';
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final User? user;
  final bool isLogoutSuccess;

  const ProfileState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.isLogoutSuccess = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? user,
    bool? isLogoutSuccess,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      isLogoutSuccess: isLogoutSuccess ?? this.isLogoutSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, user, isLogoutSuccess];
}
