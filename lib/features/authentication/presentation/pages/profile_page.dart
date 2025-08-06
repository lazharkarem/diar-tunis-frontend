import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_event.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLogoutSuccess) {
            context.go('/login');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthAuthenticated) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user.avatar != null
                        ? NetworkImage(user.avatar!) as ImageProvider
                        : const AssetImage('assets/images/default_avatar.png'),
                    child: user.avatar == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.textSecondary,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'User Type: ${user.userType.toUpperCase()}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: AppColors.divider),
                  const SizedBox(height: 24),
                  _buildProfileInfoRow(
                    'Phone',
                    user.phone ?? 'N/A',
                    Icons.phone,
                  ),
                  _buildProfileInfoRow(
                    'Verified',
                    user.isVerified ? 'Yes' : 'No',
                    user.isVerified ? Icons.check_circle : Icons.cancel,
                    color: user.isVerified
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  _buildProfileInfoRow(
                    'Member Since',
                    '${user.createdAt.year}-${user.createdAt.month}-${user.createdAt.day}',
                    Icons.calendar_today,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to edit profile page
                      },
                      child: const Text('Edit Profile'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Navigate to change password page
                      },
                      child: const Text('Change Password'),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is AuthUnauthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You are not logged in.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Something went wrong!'));
        },
      ),
    );
  }

  Widget _buildProfileInfoRow(
    String title,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color ?? AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyLarge.copyWith(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
