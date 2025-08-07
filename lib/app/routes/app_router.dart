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
import 'package:diar_tunis/features/guest/presentation/pages/guest_home_page.dart';
import 'package:diar_tunis/features/guest/presentation/pages/property_details_page.dart';
import 'package:diar_tunis/features/host/presentation/pages/bookings_list_page.dart';
import 'package:diar_tunis/features/host/presentation/pages/earnings_page.dart';
import 'package:diar_tunis/features/host/presentation/pages/host_dashboard_page.dart';
import 'package:diar_tunis/features/host/presentation/pages/my_properties_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      GoRoute(
        path: '/',
        redirect: (context, state) => AppRoutes.splash,
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
      GoRoute(
        path: AppRoutes.hostHome,
        builder: (BuildContext context, GoRouterState state) =>
            const HostDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.hostProperties,
        builder: (BuildContext context, GoRouterState state) =>
            const MyPropertiesPage(),
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
      GoRoute(
        path: AppRoutes.addProperty,
        builder: (BuildContext context, GoRouterState state) =>
            const MyPropertiesPage(), // Replace with AddPropertyPage when available
      ),
      GoRoute(
        path: AppRoutes.editProperty,
        builder: (BuildContext context, GoRouterState state) {
          final propertyId = state.pathParameters['id']!;
          return const MyPropertiesPage(); // Replace with EditPropertyPage when available
        },
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
            const GuestHomePage(), // Replace with SearchPage when available
      ),
      GoRoute(
        path: AppRoutes.favorites,
        builder: (BuildContext context, GoRouterState state) =>
            const GuestHomePage(), // Replace with FavoritesPage when available
      ),

      // Common routes
      GoRoute(
        path: AppRoutes.profile,
        builder: (BuildContext context, GoRouterState state) =>
            const GuestHomePage(), // Replace with ProfilePage when available
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (BuildContext context, GoRouterState state) =>
            const GuestHomePage(), // Replace with SettingsPage when available
      ),
    ],
  );
}
