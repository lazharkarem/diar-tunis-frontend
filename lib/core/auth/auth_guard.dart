import 'package:diar_tunis/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:diar_tunis/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;

    // Debug logging
    print('=== AUTH GUARD DEBUG ===');
    print('Current Route: ${state.uri.path}');
    print('Auth State Type: ${authState.runtimeType}');

    if (authState is AuthLoading) {
      return null;
    }

    if (authState is AuthUnauthenticated || authState is AuthInitial) {
      print('[AuthGuard] User is unauthenticated, checking route');
      final publicRoutes = ['/splash', '/onboarding', '/login', '/register'];
      if (publicRoutes.contains(state.uri.path)) {
        return null;
      }
      return '/splash';
    }

    if (authState is AuthAuthenticated) {
      final user = authState.user;
      final userType = (user.userType ?? 'guest').toLowerCase().trim();

      print('Authenticated User:');
      print('Type: $userType');
      print('ID: ${user.id}');
      print('Email: ${user.email}');

      // Handle routes based on user type
      if (userType == 'admin' && !state.uri.path.startsWith('/admin')) {
        print('[AuthGuard] Admin user not on admin route, redirecting to /admin');
        return '/admin';
      } else if (userType == 'host' && !state.uri.path.startsWith('/host')) {
        print('[AuthGuard] Host user not on host route, redirecting to /host');
        return '/host';
      } else if (userType == 'guest' && !state.uri.path.startsWith('/guest')) {
        print('[AuthGuard] Guest user not on guest route, redirecting to /guest');
        return '/guest';
      }

      // Allow access to public routes for authenticated users
      if (['/login', '/register'].contains(state.uri.path)) {
        return userType == 'admin'
            ? '/admin'
            : userType == 'host'
            ? '/host'
            : '/guest';
      }

      return null;
    }

    return null;
  }
}
