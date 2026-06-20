import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/presentation/incidents/incident_screen.dart';
import 'package:chef_king/presentation/leave/leave_screen.dart';
import 'package:flutter/cupertino.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.splash => _buildPageRoute(const SplashScreen(), settings),
      AppRoutes.main => _buildPageRoute(const MainScreen(), settings),
      AppRoutes.login => _buildPageRoute(const LoginScreen(), settings),
      AppRoutes.forgotPassword =>
          _buildPageRoute(const ForgotPasswordScreen(), settings),
      AppRoutes.incidents => _buildPageRoute(const IncidentScreen(), settings),
      AppRoutes.leave => _buildPageRoute(const LeaveScreen(), settings),
      _ => _buildPageRoute(
        Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
        settings,
      ),
    };
  }

  static Route<dynamic> _buildPageRoute(Widget child, RouteSettings settings) =>
      Platform.isIOS
      ? CupertinoPageRoute(builder: (_) => child, settings: settings)
      : PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => child,
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOutCubic)),
            ),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 500),
        );
}
