import 'package:chef_king/core/imports/app_imports.dart';
import 'package:chef_king/presentation/documents/document_screen.dart';
import 'package:chef_king/presentation/profile/edit_profile_screen.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final user = state.user;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              // Profile Image
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryBlue,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: CKImage(
                      imagePath: user?.profile ?? AppAssets.profileIcon,
                      fit: BoxFit.cover,
                      placeholder: AppAssets.profileIcon,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // User Name
              CKText(
                user?.name ?? 'Guest User',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              // User ID
              CKText(
                'ID: ${user?.guards?.id ?? user?.id ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.subTitleTextColor,
                ),
              ),
              const SizedBox(height: 40),

              // Profile Options
              _ProfileOption(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                subtitle: 'Name, photo, personal & address details',
                onTap: () async {
                  if (user == null) return;
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(user: user),
                    ),
                  );
                  if (updated == true && context.mounted) {
                    context.read<ProfileBloc>().add(LoadProfileData());
                  }
                },
              ),
              _ProfileOption(
                icon: Icons.business_outlined,
                title: 'Assigned Location',
                subtitle: user?.guards?.city ?? 'Not assigned',
                onTap: () {},
              ),
              _ProfileOption(
                icon: Icons.folder_shared_outlined,
                title: 'My Documents',
                subtitle: 'Licenses, certifications & expiry status',
                onTap: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DocumentScreen()),
                  );
                  if (updated == true && context.mounted) {
                    context.read<ProfileBloc>().add(LoadProfileData());
                  }
                },
              ),

              const SizedBox(height: 40),

              // Logout Button
              GestureDetector(
                onTap: () {
                  context.read<ProfileBloc>().add(LogoutRequested());
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    CKText(
                      'Logout',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.buttonColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryBlue, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CKText(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CKText(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.subTitleTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.subTitleTextColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
