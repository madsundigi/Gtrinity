import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileData extends ProfileEvent {}

class LogoutRequested extends ProfileEvent {}

class ClearLogoutState extends ProfileEvent {}
