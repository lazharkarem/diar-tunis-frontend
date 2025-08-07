import 'package:diar_tunis/app/routes/app_routes.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/authentication/presentation/bloc/auth_state.dart';

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
    // Check authentication status when the guard initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthCheckRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        final currentLocation = GoRouterState.of(context).uri.toString();

        if (state is AuthAuthenticated) {
          // User is authenticated - redirect to appropriate dashboard if on auth pages
          if (_isAuthRoute(currentLocation)) {
            _redirectBasedOnUserType(state.user.userType, context);
          }
        } else if (state is AuthUnauthenticated) {
          // User is not authenticated - redirect to login if not on auth pages
          if (!_isAuthRoute(currentLocation)) {
            context.go(AppRoutes.login);
          }
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
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

        // For unauthenticated state, we might still show child if it's a public route
        // The listener will handle redirection
        return widget.child;
      },
    );
  }

  bool _isAuthRoute(String location) {
    return location == AppRoutes.login ||
        location == AppRoutes.register ||
        location == AppRoutes.splash ||
        location == AppRoutes.onboarding ||
        location == AppRoutes.forgotPassword;
  }

  void _redirectBasedOnUserType(String userType, BuildContext context) {
    switch (userType.toLowerCase()) {
      case 'admin':
        context.go(AppRoutes.adminHome);
        break;
      case 'host':
        context.go(AppRoutes.hostHome);
        break;
      case 'guest':
      case 'service_customer':
      default:
        context.go(AppRoutes.guestHome); // This should match your constant
    }
  }
}
