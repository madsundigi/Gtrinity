import 'package:chef_king/core/imports/app_imports.dart';

import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordBody extends StatefulWidget {
  final ForgotPasswordState state;

  const ForgotPasswordBody({super.key, required this.state});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.state.email);
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              _buildFormField(context),
              const SizedBox(height: 32),
              _buildButton(context),
            ],
          ),
        ),
      ),
    );
  }

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
          AppStrings.forgotPassword,
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: 26,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 8),
        CKText(
          AppStrings.enterEmailToReset,
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: 14,
            color: AppColors.subTitleTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(BuildContext context) {
    return CKInputField(
      controller: _emailController,
      hintText: AppStrings.emailHint,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(AppAssets.emailIcon, width: 20, height: 16),
      ),
      errorText: widget.state.emailError,
      onChanged: (value) {
        context.read<ForgotPasswordBloc>().add(ForgotEmailChanged(value));
      },
    );
  }

  Widget _buildButton(BuildContext context) {
    return CKButton(
      label: AppStrings.resetPassword,
      onPressed: () {
        context
            .read<ForgotPasswordBloc>()
            .add(ForgotPasswordSubmitted(_emailController.text));
      },
    );
  }
}

