import '../../../core/imports/app_imports.dart';
import '../../../domain/usecases/auth/AuthUseCase.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthUseCase authUseCase;

  ForgotPasswordBloc({required this.authUseCase})
      : super(const ForgotPasswordState()) {
    on<ForgotEmailChanged>(_onEmailChanged);
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
      ForgotEmailChanged event, Emitter<ForgotPasswordState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        emailError: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final emailError = authUseCase.validateEmail(event.email);

    if (emailError != null) {
      emit(state.copyWith(emailError: emailError));
      return;
    }

    // If valid → call forgot password API
  }
}

