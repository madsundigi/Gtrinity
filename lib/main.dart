import 'package:chef_king/core/imports/app_imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppCache.init();
  await init();
  runApp(
    MultiBlocProvider(
      providers: AppBlocProviders.allProviders,
      child: const MyApp(),
    ),
  );
}
