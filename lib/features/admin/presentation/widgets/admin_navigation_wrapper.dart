import 'package:diar_tunis/app/routes/app_routes.dart';
import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminNavigationWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final int currentIndex;
  final Widget? floatingActionButton;

  const AdminNavigationWrapper({
    super.key,
    required this.child,
    required this.title,
    required this.currentIndex,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        
        // Prevent app from closing on back button press
        // Instead, navigate to login page or handle gracefully
        if (currentIndex != 0) {
          context.go(AppRoutes.adminHome);
          return;
        }
        // Show confirmation dialog for dashboard
        final shouldExit = await _showExitConfirmation(context);
        if (shouldExit && context.mounted) {
          // Allow the pop to complete
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: false,
          leading: currentIndex == 0 
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go(AppRoutes.adminHome),
              ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications coming soon!')),
                );
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'profile':
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile coming soon!')),
                    );
                    break;
                  case 'settings':
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings coming soon!')),
                    );
                    break;
                  case 'logout':
                    _showLogoutConfirmation(context);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'profile',
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'settings',
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Logout', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
        body: child,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Properties',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online),
              label: 'Bookings',
            ),
          ],
          onTap: (index) {
            print('[AdminNavigationWrapper] Bottom nav tapped: index=$index, currentIndex=$currentIndex');
            switch (index) {
              case 0:
                if (currentIndex != 0) {
                  print('[AdminNavigationWrapper] Navigating to admin home');
                  context.go(AppRoutes.adminHome);
                }
                break;
              case 1:
                if (currentIndex != 1) {
                  print('[AdminNavigationWrapper] Navigating to admin users');
                  context.go(AppRoutes.adminUsers);
                }
                break;
              case 2:
                if (currentIndex != 2) {
                  print('[AdminNavigationWrapper] Navigating to admin properties');
                  context.go(AppRoutes.adminProperties);
                }
                break;
              case 3:
                if (currentIndex != 3) {
                  print('[AdminNavigationWrapper] Navigating to admin bookings');
                  context.go(AppRoutes.adminBookings);
                }
                break;
            }
          },
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Trigger logout event in AuthBloc
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            child: const Text('Logout'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
