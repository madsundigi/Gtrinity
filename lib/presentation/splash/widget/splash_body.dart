import 'package:chef_king/core/imports/app_imports.dart';

class SplashBody extends StatelessWidget {
  final SplashState state;

  const SplashBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLogo(),
          SizedBox(height: 16),
          _buildAppName(context),
          _buildSubTitle(context),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return const CKImage(imagePath: AppAssets.appLogo, width: 200, height: 200);
  }

  Widget _buildAppName(BuildContext context) {
    return CKText(
      AppStrings.appName,
      style: context.textTheme.titleLarge?.copyWith(
        fontSize: 48,
        color: AppColors.logoText,
      ),
    );
  }

  Widget _buildSubTitle(BuildContext context) {
    return CKText(
      AppStrings.appSubTitle,
      style: context.textTheme.titleMedium?.copyWith(
        color: AppColors.subTitleTextColor,
        fontSize: 14,
        letterSpacing: 2,
      ),
    );
  }
}
