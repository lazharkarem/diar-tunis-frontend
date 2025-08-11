import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_event.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_state.dart';
import 'package:diar_tunis/features/guest/presentation/widgets/guest_navigation_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class GuestProfilePage extends StatelessWidget {
  const GuestProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GuestNavigationWrapper(
      title: 'Profile',
      currentIndex: 4,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            // If guest is somehow authenticated, show their profile
            final user = state.user;
            return _buildAuthenticatedProfile(context, user);
          } else {
            // Show guest profile options
            return _buildGuestProfile(context);
          }
        },
      ),
    );
  }

  Widget _buildAuthenticatedProfile(BuildContext context, User user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header with background
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                // Profile image with border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: user.avatar != null
                        ? NetworkImage(user.avatar!) as ImageProvider
                        : const AssetImage('assets/images/default_avatar.png'),
                    child: user.avatar == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                // User name with shadow
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // User email
                Text(
                  user.email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                // User type badge
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.userType.toUpperCase(),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          
          // Profile information section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title
                Text(
                  'Personal Information',
                  style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Info cards
                _buildInfoCard(
                  icon: Icons.phone,
                  title: 'Phone Number',
                  value: user.phone ?? 'Not provided',
                  iconColor: AppColors.secondary,
                ),
                _buildInfoCard(
                  icon: user.isVerified ? Icons.verified_user : Icons.cancel,
                  title: 'Account Status',
                  value: user.isVerified ? 'Verified Account' : 'Not Verified',
                  iconColor: user.isVerified ? AppColors.success : AppColors.error,
                ),
                _buildInfoCard(
                  icon: Icons.calendar_today,
                  title: 'Member Since',
                  value: '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                  iconColor: AppColors.accent,
                ),
                
                const SizedBox(height: 30),
                // Section title
                Text(
                  'Account Settings',
                  style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Action buttons
                _buildActionButton(
                  context: context,
                  icon: Icons.edit,
                  text: 'Edit Profile',
                  color: AppColors.primary,
                  onTap: () {
                    // Navigate to edit profile page
                    // TODO: Implement edit profile functionality
                  },
                ),
                _buildActionButton(
                  context: context,
                  icon: Icons.lock,
                  text: 'Change Password',
                  color: AppColors.secondary,
                  onTap: () {
                    // Navigate to change password page
                    // TODO: Implement change password functionality
                  },
                ),
                _buildActionButton(
                  context: context,
                  icon: Icons.logout,
                  text: 'Logout',
                  color: AppColors.error,
                  onTap: () {
                    // Logout
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestProfile(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header with background
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Guest avatar with animation effect
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person, size: 60, color: AppColors.primary),
                ),
                const SizedBox(height: 20),
                // Welcome text with shadow
                Text(
                  'Welcome, Guest',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Subtitle
                Text(
                  'Discover Diar Tunis',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          
          // Main content
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account options section
                Text(
                  'Account Options',
                  style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // Login card
                _buildGuestOptionCard(
                  context: context,
                  title: 'Login to your account',
                  description: 'Access your saved properties and booking history',
                  icon: Icons.login,
                  color: AppColors.secondary,
                  onTap: () => context.go('/login'),
                ),
                
                // Register card
                _buildGuestOptionCard(
                  context: context,
                  title: 'Create an account',
                  description: 'Save favorites and get personalized recommendations',
                  icon: Icons.person_add,
                  color: AppColors.primary,
                  onTap: () => context.go('/register'),
                ),
                
                // Continue as guest card
                _buildGuestOptionCard(
                  context: context,
                  title: 'Continue as guest',
                  description: 'Browse properties without an account',
                  icon: Icons.explore,
                  color: AppColors.accent,
                  onTap: () => context.go('/guest'),
                ),
                
                const SizedBox(height: 30),
                
                // Features section with card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Features',
                        style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem('Search Properties', Icons.search),
                      const Divider(height: 24),
                      _buildFeatureItem('View Property Details', Icons.home),
                      const Divider(height: 24),
                      _buildFeatureItem('Contact Hosts', Icons.message),
                      const Divider(height: 24),
                      _buildFeatureItem('Save Favorites', Icons.favorite),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestOptionCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon with gradient background
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // New helper widgets for the redesigned profile page
  
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton({
     required BuildContext context,
     required IconData icon,
     required String text,
     required Color color,
     required VoidCallback onTap,
   }) {
     return Container(
       margin: const EdgeInsets.only(bottom: 16),
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(12),
         boxShadow: [
           BoxShadow(
             color: color.withOpacity(0.1),
             blurRadius: 8,
             offset: const Offset(0, 2),
           ),
         ],
       ),
       child: Material(
         color: Colors.white,
         borderRadius: BorderRadius.circular(12),
         clipBehavior: Clip.antiAlias,
         child: InkWell(
           onTap: onTap,
           splashColor: color.withOpacity(0.1),
           highlightColor: color.withOpacity(0.05),
           child: Padding(
             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
             child: Row(
               children: [
                 Icon(icon, color: color, size: 24),
                 const SizedBox(width: 16),
                 Expanded(
                   child: Text(
                     text,
                     style: AppTextStyles.bodyLarge.copyWith(
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                 ),
                 Icon(Icons.arrow_forward_ios, color: color, size: 16),
               ],
             ),
           ),
         ),
       ),
     );
   }
}
