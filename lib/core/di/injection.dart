import 'package:chef_king/core/imports/app_imports.dart';
import '../services/location_service.dart';
import '../../data/repositories/auth/auth_repository_impl.dart';
import '../../domain/repositories/auth/auth_repository.dart';
import '../../data/repositories/home/home_repository_impl.dart';
import '../../domain/repositories/home/home_repository.dart';
import '../../domain/usecases/home/home_use_case.dart';
import '../../presentation/home/bloc/home_bloc.dart';
import '../../presentation/profile/bloc/profile_bloc.dart';
import '../../presentation/duties/bloc/duties_bloc.dart';
import '../../domain/repositories/incident_repository.dart';
import '../../data/repositories/incident/incident_repository_impl.dart';
import '../../domain/repositories/leave_repository.dart';
import '../../data/repositories/leave/leave_repository_impl.dart';
import '../../presentation/incidents/cubit/incidents_cubit.dart';
import '../../presentation/leave/cubit/leave_cubit.dart';
import '../../domain/repositories/document_repository.dart';
import '../../data/repositories/document/document_repository_impl.dart';
import '../../presentation/documents/cubit/document_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<LocationService>(() => LocationService());

  // Data sources

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton<IncidentRepository>(() => IncidentRepositoryImpl(dio: sl<ApiClient>().dio));
  sl.registerLazySingleton<LeaveRepository>(() => LeaveRepositoryImpl(dio: sl<ApiClient>().dio));
  sl.registerLazySingleton<DocumentRepository>(() => DocumentRepositoryImpl(dio: sl<ApiClient>().dio));

  // Use cases
  sl.registerLazySingleton<AuthUseCase>(() => AuthUseCase(sl()));
  sl.registerLazySingleton<HomeUseCase>(() => HomeUseCase(sl()));

  // Blocs
  sl.registerFactory(() => MainBloc());
  sl.registerFactory(() => SplashBloc());
  sl.registerFactory(() => AuthBloc(authUseCase: sl()));
  sl.registerFactory(() => ForgotPasswordBloc(authUseCase: sl()));
  sl.registerFactory(() => HomeBloc(homeUseCase: sl(), locationService: sl()));
  sl.registerFactory(() => ProfileBloc(authUseCase: sl()));
  sl.registerFactory(() => DutiesBloc(homeUseCase: sl()));
  sl.registerFactory(() => IncidentsCubit(repository: sl()));
  sl.registerFactory(() => LeaveCubit(repository: sl()));
  sl.registerFactory(() => DocumentCubit(repository: sl()));
}
