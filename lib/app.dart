import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/core/routes/app_router.dart';
import 'package:chef_king/core/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? _buildCupertinoApp() : _buildMaterialApp();
  }

  Widget _buildCupertinoApp() {
    return const CupertinoApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        primaryColor: AppColors.primary,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontFamily: 'Montserrat'),
        ),
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }

  Widget _buildMaterialApp() {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
