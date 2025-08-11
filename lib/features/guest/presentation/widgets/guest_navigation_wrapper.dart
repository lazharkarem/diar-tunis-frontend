import 'package:diar_tunis/app/routes/app_routes.dart';
import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GuestNavigationWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final int currentIndex;
  final Widget? floatingActionButton;

  const GuestNavigationWrapper({
    super.key,
    required this.child,
    required this.title,
    required this.currentIndex,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      child: PopScope(
        onPopInvoked: (didPop) async {
          if (currentIndex == 0) {
            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Exit App'),
                content: const Text('Are you sure you want to exit the app?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Exit'),
                  ),
                ],
              ),
            );
            if (shouldExit == true) {
              // Exit the app
              Navigator.of(context).pop();
            }
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: child,
          bottomNavigationBar: _buildBottomNavigationBar(context),
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.h5.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      actions: [
        IconButton(
          onPressed: () {
            // Navigate to notifications
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
        
            // Navigate to profile
             onPressed: () => context.go(AppRoutes.profile),
          
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => _navigateToPage(context, 0),
              ),
              _buildNavItem(
                context,
                icon: Icons.search_outlined,
                activeIcon: Icons.search,
                label: 'Search',
                isActive: currentIndex == 1,
                onTap: () => _navigateToPage(context, 1),
              ),
              _buildNavItem(
                context,
                icon: Icons.favorite_outline,
                activeIcon: Icons.favorite,
                label: 'Favorites',
                isActive: currentIndex == 2,
                onTap: () => _navigateToPage(context, 2),
              ),
              _buildNavItem(
                context,
                icon: Icons.history_outlined,
                activeIcon: Icons.history,
                label: 'Bookings',
                isActive: currentIndex == 3,
                onTap: () => _navigateToPage(context, 3),
              ),
              _buildNavItem(
                context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                isActive: currentIndex == 4,
                onTap: () => _navigateToPage(context, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTextStyles.labelSmall.copyWith(
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        context.go(AppRoutes.guestHome);
        break;
      case 1:
        context.go(AppRoutes.search);
        break;
      case 2:
        context.go(AppRoutes.favorites);
        break;
      case 3:
        context.go(AppRoutes.bookings);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }
}
