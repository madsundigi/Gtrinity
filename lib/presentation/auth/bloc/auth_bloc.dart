import 'package:chef_king/core/imports/app_imports.dart';
import '../../../data/models/auth/LoginRequest.dart';
import '../../../data/models/auth/LoginResponse.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase authUseCase;

  AuthBloc({required this.authUseCase}) : super(const AuthState()) {
    on<EmailChanged>(
      (event, emit) => _updateField(emit, email: event.email, emailError: null),
    );

    on<PasswordChanged>(
      (event, emit) =>
          _updateField(emit, password: event.password, passwordError: null),
    );

    on<LoginSubmitted>(_onLoginSubmitted);
    on<ClearMessages>(
      (event, emit) =>
          emit(state.copyWith(successMessage: null, errorMessage: null)),
    );
    on<ResetAuthForm>((event, emit) => emit(const AuthState()));
  }

  void _updateField(
    Emitter<AuthState> emit, {
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
  }) {
    emit(
      state.copyWith(
        email: email ?? state.email,
        password: password ?? state.password,
        emailError: emailError,
        passwordError: passwordError,
      ),
    );
  }

  bool _validateForm(Emitter<AuthState> emit) {
    final validation = authUseCase.validateForm(
      email: state.email,
      password: state.password,
    );

    if (validation.emailError != null || validation.passwordError != null) {
      emit(
        state.copyWith(
          emailError: validation.emailError,
          passwordError: validation.passwordError,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (!_validateForm(emit)) return;

    emit(
      state.copyWith(isLoading: true, successMessage: null, errorMessage: null),
    );
    try {
      final response = await authUseCase.login(event.loginRequest);
      if (response.success == true) {
        await AppCache.saveLoginResponse(response);
        emit(
          state.copyWith(
            isLoading: false,
            successMessage: response.message ?? 'Login Successful',
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: response.message ?? 'Login Failed',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
