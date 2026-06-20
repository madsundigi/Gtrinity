import '../../core/imports/app_imports.dart';
import 'bloc/forgot_password_bloc.dart';
import 'widget/forgot_password_body.dart';

class ForgotPasswordScreen
    extends CKBaseScreen<ForgotPasswordBloc, ForgotPasswordState> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget buildBody(BuildContext context, ForgotPasswordState state) {
    return ForgotPasswordBody(state: state);
  }

  @override
  void listener(BuildContext context, ForgotPasswordState state) {
    // Handle navigation / messages when you wire the API
  }
}
