import 'package:diar_tunis/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_event.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  @override
  void initState() {
    super.initState();
    // Check authentication status when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthCheckRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // User is authenticated, navigate to appropriate dashboard based on user type
          final userType = state.user.userType.toLowerCase();
          String route = '/guest_home'; // default

          switch (userType) {
            case 'admin':
              route = '/admin_dashboard';
              break;
            case 'host':
              route = '/host_dashboard';
              break;
            case 'guest':
            case 'service_customer':
              route = '/guest_home';
              break;
            default:
              route = '/guest_home';
          }

          // Only navigate if we're currently on login/register page
          final currentRoute = GoRouterState.of(context).uri.toString();
          if (currentRoute == '/login' || 
              currentRoute == '/register' || 
              currentRoute == '/' ||
              currentRoute == '/splash') {
            context.go(route);
          }
        } else if (state is AuthUnauthenticated) {
          // User is not authenticated, navigate to login only if not already there
          final currentRoute = GoRouterState.of(context).uri.toString();
          if (currentRoute != '/login' && 
              currentRoute != '/register' &&
              currentRoute != '/') {
            context.go('/login');
          }
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading && state is! AuthAuthenticated && state is! AuthUnauthenticated) {
            // Show loading screen while checking authentication
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading...'),
                  ],
                ),
              ),
            );
          }
          
          // Return the child widget (the actual page content)
          return widget.child;
        },
      ),
    );
  }
}
