import 'package:diar_tunis/app/routes/app_routes.dart';
import 'package:diar_tunis/core/auth/auth_guard.dart';
import 'package:diar_tunis/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:diar_tunis/features/admin/presentation/pages/booking_management_page.dart';
import 'package:diar_tunis/features/admin/presentation/pages/property_management_page.dart';
import 'package:diar_tunis/features/admin/presentation/pages/user_management_page.dart';
import 'package:diar_tunis/features/authentication/presentation/pages/login_page.dart';
import 'package:diar_tunis/features/authentication/presentation/pages/register_page.dart';
import 'package:diar_tunis/features/authentication/presentation/pages/splash_page.dart';
import 'package:diar_tunis/features/guest/presentation/pages/booking_history_page.dart';
import 'package:diar_tunis/features/guest/presentation/pages/booking_page.dart';
import 'package:diar_tunis/features/guest/presentation/pages/guest_bookings_page.dart';
import 'package:diar_tunis/features/guest/presentation/pages/guest_favorites_page.dart';
import 'package:diar_tunis/features/guest/presentation/pages/guest_home_page.dart';
import 'package:diar_tunis/features/guest/presentation/pages/guest_profile_page.dart';
import 'package:diar_tunis/features/guest/presentation/pages/property_details_page.dart';
import 'package:diar_tunis/features/guest/presentation/pages/guest_search_page.dart';
import 'package:diar_tunis/features/host/presentation/pages/bookings_list_page.dart';
import 'package:diar_tunis/features/host/presentation/pages/earnings_page.dart';
import 'package:diar_tunis/features/host/presentation/pages/host_dashboard_page.dart';
import 'package:diar_tunis/features/host/presentation/providers/host_property_provider.dart';
import 'package:diar_tunis/features/shared/presentation/pages/onboarding_page.dart';
import 'package:diar_tunis/features/properties/domain/repositories/property_repository.dart';
import 'package:diar_tunis/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true, // Enable debug logging
    redirect: (context, state) {
      return AuthGuard.redirect(context, state);
    },
    routes: [
      // Public routes (no authentication required)
      GoRoute(
        path: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashPage(),
      ),
      // Fallback route for root path
      GoRoute(path: '/', redirect: (context, state) => AppRoutes.splash),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),

      // Admin routes
      GoRoute(
        path: AppRoutes.adminHome,
        builder: (BuildContext context, GoRouterState state) =>
            const AdminDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.adminUsers,
        builder: (BuildContext context, GoRouterState state) =>
            const UserManagementPage(),
      ),
      GoRoute(
        path: AppRoutes.adminProperties,
        builder: (BuildContext context, GoRouterState state) =>
            const PropertyManagementPage(),
      ),
      GoRoute(
        path: AppRoutes.adminBookings,
        builder: (BuildContext context, GoRouterState state) =>
            const BookingManagementPage(),
      ),

      // Host routes
      // Host home route with providers
      GoRoute(
        path: AppRoutes.hostHome,
        builder: (BuildContext context, GoRouterState state) {
          return MultiProvider(
            providers: [
              Provider<PropertyRepository>(
                create: (context) => di.sl<PropertyRepository>(),
              ),
              ChangeNotifierProvider<HostPropertyProvider>(
                create: (context) => HostPropertyProvider(
                  di.sl<PropertyRepository>(),
                )..loadProperties(),
              ),
            ],
            child: const HostDashboardPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.hostProperties,
        builder: (BuildContext context, GoRouterState state) {
          return MultiProvider(
            providers: [
              Provider<PropertyRepository>(
                create: (context) => di.sl<PropertyRepository>(),
              ),
              ChangeNotifierProvider<HostPropertyProvider>(
                create: (context) => HostPropertyProvider(
                  di.sl<PropertyRepository>(),
                )..loadProperties(),
              ),
            ],
            child: const HostDashboardPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.hostBookings,
        builder: (BuildContext context, GoRouterState state) =>
            const BookingsListPage(),
      ),
      GoRoute(
        path: AppRoutes.hostEarnings,
        builder: (BuildContext context, GoRouterState state) =>
            const EarningsPage(),
      ),
      // Add property route - redirect to host home for now
      GoRoute(
        path: AppRoutes.addProperty,
        redirect: (context, state) => AppRoutes.hostHome,
      ),
      // Edit property route - redirect to host home for now
      GoRoute(
        path: AppRoutes.editProperty,
        redirect: (context, state) => AppRoutes.hostHome,
      ),

      // Guest routes
      GoRoute(
        path: AppRoutes.guestHome,
        builder: (BuildContext context, GoRouterState state) =>
            const GuestHomePage(),
      ),
      GoRoute(
        path: AppRoutes.propertyDetails,
        builder: (BuildContext context, GoRouterState state) {
          final propertyId = state.pathParameters['id']!;
          return PropertyDetailsPage(propertyId: propertyId);
        },
      ),
      GoRoute(
        path: AppRoutes.booking,
        builder: (BuildContext context, GoRouterState state) =>
            const BookingPage(),
      ),
      GoRoute(
        path: AppRoutes.bookingHistory,
        builder: (BuildContext context, GoRouterState state) =>
            const BookingHistoryPage(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (BuildContext context, GoRouterState state) =>
            const GuestSearchPage(),
      ),
      GoRoute(
        path: AppRoutes.favorites,
        builder: (BuildContext context, GoRouterState state) =>
            const GuestFavoritesPage(),
      ),
      GoRoute(
        path: AppRoutes.bookings,
        builder: (BuildContext context, GoRouterState state) =>
            const GuestBookingsPage(),
      ),

      // Common routes
      GoRoute(
        path: AppRoutes.profile,
        builder: (BuildContext context, GoRouterState state) =>
            const GuestProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (BuildContext context, GoRouterState state) =>
            const GuestHomePage(), // Replace with SettingsPage when available
      ),
    ],
  );
}
