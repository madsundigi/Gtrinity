import 'package:chef_king/core/imports/app_imports.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';
import 'widget/profile_body.dart';

class ProfileScreen extends CKBaseScreen<ProfileBloc, ProfileState> {
  const ProfileScreen({super.key});

  @override
  void onInit(BuildContext context) {
    context.read<ProfileBloc>().add(LoadProfileData());
  }

  @override
  void listener(BuildContext context, ProfileState state) {
    if (state.isLogoutSuccess) {
      // 1. Reset MainBloc state to index 0 so next login starts fresh on Home tab
      context.read<MainBloc>().add(ResetTab());
      
      // 2. Reset AuthBloc to clear login form fields
      context.read<AuthBloc>().add(ResetAuthForm());

      // 3. Clear navigation stack and go to login
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
    if (state.errorMessage != null && !state.isLogoutSuccess) {
      CKSnackBar.showError(context, state.errorMessage!);
    }
  }

  @override
  bool isLoading(ProfileState state) => state.isLoading;

  @override
  Color? get backgroundColor => AppColors.darkBackground;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: const CKText(
        AppStrings.profile,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context, ProfileState state) {
    return const ProfileBody();
  }
}
