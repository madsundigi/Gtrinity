import 'package:chef_king/core/imports/app_imports.dart';

class SplashScreen extends CKBaseScreen<SplashBloc, SplashState> {
  const SplashScreen({super.key});

  @override
  void onInit(BuildContext context) {
    context.read<SplashBloc>().add(SplashStarted());
  }

  @override
  bool listenWhen(SplashState previous, SplashState current) =>
      current is NavigateToLogin ||
      current is NavigateToMain;

  @override
  void listener(BuildContext context, SplashState state) {
    switch (state) {
      case NavigateToLogin():
        context.pushReplacementNamed(AppRoutes.login);
        break;
      case NavigateToMain():
        context.pushReplacementNamed(AppRoutes.main);
        break;
    }
  }

  @override
  Widget buildBody(BuildContext context, SplashState state) {
    return SplashBody(state: state);
  }
}
