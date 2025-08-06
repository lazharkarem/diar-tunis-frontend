import 'package:diar_tunis/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:diar_tunis/features/admin/presentation/pages/booking_management_page.dart';
import 'package:diar_tunis/features/admin/presentation/pages/property_management_page.dart';
import 'package:diar_tunis/features/admin/presentation/pages/user_management_page.dart';
import 'package:diar_tunis/features/authentication/presentation/pages/login_page.dart';
import 'package:diar_tunis/features/authentication/presentation/pages/register_page.dart';
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
    initialLocation: '/login',
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),
      GoRoute(
        path: '/admin_dashboard',
        builder: (BuildContext context, GoRouterState state) =>
            const AdminDashboardPage(),
      ),
      GoRoute(
        path: '/admin_properties',
        builder: (BuildContext context, GoRouterState state) =>
            const PropertyManagementPage(),
      ),
      GoRoute(
        path: '/admin_users',
        builder: (BuildContext context, GoRouterState state) =>
            const UserManagementPage(),
      ),
      GoRoute(
        path: '/admin_bookings',
        builder: (BuildContext context, GoRouterState state) =>
            const BookingManagementPage(),
      ),
      GoRoute(
        path: '/host_dashboard',
        builder: (BuildContext context, GoRouterState state) =>
            const HostDashboardPage(),
      ),
      GoRoute(
        path: '/host_my_properties',
        builder: (BuildContext context, GoRouterState state) =>
            const MyPropertiesPage(),
      ),
      GoRoute(
        path: '/host_bookings',
        builder: (BuildContext context, GoRouterState state) =>
            const BookingsListPage(),
      ),
      GoRoute(
        path: '/host_earnings',
        builder: (BuildContext context, GoRouterState state) =>
            const EarningsPage(),
      ),
      GoRoute(
        path: '/guest_home',
        builder: (BuildContext context, GoRouterState state) =>
            const GuestHomePage(),
      ),
      GoRoute(
        path: '/property_details/:propertyId',
        builder: (BuildContext context, GoRouterState state) =>
            PropertyDetailsPage(
              propertyId: state.pathParameters["propertyId"]!,
            ),
      ),
      GoRoute(
        path: '/book_property',
        builder: (BuildContext context, GoRouterState state) =>
            const BookingPage(),
      ),
      GoRoute(
        path: '/guest_bookings',
        builder: (BuildContext context, GoRouterState state) =>
            const BookingHistoryPage(),
      ),
    ],
  );
}
