part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends SplashState {}

class Loading extends SplashState {}

class NavigateToMain extends SplashState {}

class NavigateToLogin extends SplashState {}
