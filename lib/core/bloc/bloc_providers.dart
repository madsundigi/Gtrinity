import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/presentation/profile/bloc/profile_bloc.dart';

import '../../presentation/auth/bloc/forgot_password_bloc.dart';

class AppBlocProviders {
  static List<SingleChildWidget> get allProviders => [
    BlocProvider(create: (context) => sl<MainBloc>()),
    BlocProvider(create: (context) => sl<SplashBloc>()),
    BlocProvider(create: (context) => sl<AuthBloc>()),
    BlocProvider(create: (context) => sl<ForgotPasswordBloc>()),
    BlocProvider(create: (context) => sl<HomeBloc>()),
    BlocProvider(create: (context) => sl<ProfileBloc>()),
  ];
}
