import '../../core/imports/app_imports.dart';

class LoginScreen extends CKBaseScreen<AuthBloc, AuthState> {
  const LoginScreen({super.key});

  @override
  Widget buildBody(BuildContext context, AuthState state) {
    return LoginBody(state: state);
  }

  @override
  bool isLoading(AuthState state) => state.isLoading;

  @override
  void listener(BuildContext context, AuthState state) {
    if (state.successMessage != null) {
      CKSnackBar.showSuccess(context, state.successMessage!);
      context.read<AuthBloc>().add(ClearMessages());
      // First-login guards go to onboarding; completed guards to the dashboard.
      context.pushNamedAndRemoveUntil(AppRoutes.afterAuth(), (route) => false);
    }

    if (state.errorMessage != null) {
      CKSnackBar.showError(context, state.errorMessage!);
      context.read<AuthBloc>().add(ClearMessages());
    }
  }
}
