import 'package:chef_king/data/local/app_cache/app_cache.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String incidents = '/incidents';
  static const String leave = '/leave';

  /// Where a logged-in guard should land: the locked onboarding flow until
  /// their profile setup is complete, otherwise the dashboard.
  static String afterAuth() {
    final guard = AppCache.getLoginResponse()?.data?.user?.guards;
    final complete = guard?.isOnboardingComplete ?? false;
    return complete ? main : onboarding;
  }
}
