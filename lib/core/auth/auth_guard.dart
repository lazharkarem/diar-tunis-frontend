import 'package:diar_tunis/app/routes/app_routes.dart';
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
    print('Current Route: ${state.uri.toString()}');
    print('Auth State Type: ${authState.runtimeType}');

    // Handle different authentication states
    if (authState is AuthLoading) {
      print('Auth is loading, staying on current route');
      return null;
    }

    if (authState is AuthUnauthenticated || authState is AuthInitial) {
      // User is not authenticated
      print('User not authenticated, redirecting to login');

      // Allow access to public routes
      final publicRoutes = ['/login', '/register', '/', '/splash'];
      if (publicRoutes.contains(state.uri.toString())) {
        return null;
      }

      return '/login';
    }

    if (authState is AuthAuthenticated) {
      final user = authState.user;
      final userType = user.userType.toLowerCase() ?? 'guest';

      print('User authenticated with type: $userType');
      print('User ID: ${user.id}');
      print('User Email: ${user.email}');

      // Handle user type based routing
      switch (userType) {
        case 'admin':
          if (state.uri.toString().startsWith('/admin')) {
            print('Admin user on admin route, allowing access');
            return null;
          }
          if (state.uri.toString() == '/login' ||
              state.uri.toString() == '/register' ||
              state.uri.toString() == '/') {
            print('Admin user on public route, redirecting to admin home');
            return AppRoutes.adminHome;
          }
          // If admin tries to access host/guest routes, redirect to admin
          if (state.uri.toString().startsWith('/host') ||
              state.uri.toString().startsWith('/guest')) {
            print(
              'Admin user trying to access non-admin route, redirecting to admin home',
            );
            return AppRoutes.adminHome;
          }
          print('Admin user on unhandled route, redirecting to admin home');
          return AppRoutes.adminHome;

        case 'host':
          if (state.uri.toString().startsWith('/host')) {
            print('Host user on host route, allowing access');
            return null;
          }
          if (state.uri.toString() == '/login' ||
              state.uri.toString() == '/register' ||
              state.uri.toString() == '/') {
            print('Host user on public route, redirecting to host home');
            return AppRoutes.hostHome;
          }
          // If host tries to access admin/guest routes, redirect to host
          if (state.uri.toString().startsWith('/admin') ||
              state.uri.toString().startsWith('/guest')) {
            print(
              'Host user trying to access non-host route, redirecting to host home',
            );
            return AppRoutes.hostHome;
          }
          print('Host user on unhandled route, redirecting to host home');
          return AppRoutes.hostHome;

        case 'guest':
        default:
          if (state.uri.toString().startsWith('/guest')) {
            print('Guest user on guest route, allowing access');
            return null;
          }
          if (state.uri.toString() == '/login' ||
              state.uri.toString() == '/register' ||
              state.uri.toString() == '/') {
            print('Guest user on public route, redirecting to guest home');
            return AppRoutes.guestHome;
          }
          // If guest tries to access admin/host routes, redirect to guest
          if (state.uri.toString().startsWith('/admin') ||
              state.uri.toString().startsWith('/host')) {
            print(
              'Guest user trying to access restricted route, redirecting to guest home',
            );
            return AppRoutes.guestHome;
          }
          print('Guest user on unhandled route, redirecting to guest home');
          return AppRoutes.guestHome;
      }
    }

    print('Auth state not handled: ${authState.runtimeType}');
    return null;
  }
}
