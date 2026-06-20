import 'package:chef_king/core/imports/app_imports.dart';

import '../../../data/models/auth/LoginRequest.dart';

class LoginBody extends StatefulWidget {
  final AuthState state;

  const LoginBody({super.key, required this.state});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.state.email);
    _passwordController = TextEditingController(text: widget.state.password);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0x1A172A45),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildFormFields(context),
              const SizedBox(height: 20),
              _buildOptions(context),
              const SizedBox(height: 32),
              _buildButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 HEADER
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        CKImage(imagePath: AppAssets.appLogo, width: 80, height: 80),
        const SizedBox(height: 12),
        CKText(
          AppStrings.appName.toUpperCase(),
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: 12,
            color: AppColors.subTitleTextColor,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        CKText(
          AppStrings.secureSignIn,
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: 30,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 8),
        CKText(
          AppStrings.accessDashboard,
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: 14,
            color: AppColors.subTitleTextColor,
          ),
        ),
      ],
    );
  }

  /// 🔹 FORM FIELDS
  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        CKInputField(
          controller: _usernameController,
          hintText: AppStrings.emailHint,
          keyboardType: TextInputType.emailAddress,
          errorText: widget.state.emailError,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(AppAssets.emailIcon, width: 20, height: 16),
          ),
          onChanged: (value) {
            context.read<AuthBloc>().add(EmailChanged(value));
          },
        ),
        const SizedBox(height: 20),
        CKInputField(
          controller: _passwordController,
          hintText: AppStrings.passwordHint,
          keyboardType: TextInputType.visiblePassword,
          errorText: widget.state.passwordError,
          obscureText: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              AppAssets.passwordIcon,
              width: 20,
              height: 16,
            ),
          ),
          onChanged: (value) {
            context.read<AuthBloc>().add(PasswordChanged(value));
          },
        ),
      ],
    );
  }

  /// 🔹 OPTIONS SECTION
  Widget _buildOptions(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => context.pushNamed(AppRoutes.forgotPassword),
            child: CKText(
              AppStrings.forgotPassword,
              style: context.textTheme.titleLarge?.copyWith(
                fontSize: 12,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 BUTTON SECTION
  Widget _buildButton(BuildContext context) {
    return CKButton(
      label: AppStrings.login,
      onPressed: () {
        context.read<AuthBloc>().add(
          LoginSubmitted(
            LoginRequest(
              email: _usernameController.text,
              password: _passwordController.text,
            ),
          ),
        );
      },
    );
  }
}
