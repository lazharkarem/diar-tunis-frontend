class AppRoutes {
  // Authentication routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main navigation routes
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Guest routes
  static const String guestHome = '/guest/home';
  static const String propertyDetails = '/property/:id';
  static const String booking = '/booking';
  static const String bookingHistory = '/booking-history';
  static const String search = '/guest/search';
  static const String favorites = '/guest/favorites';
  static const String bookings = '/guest/bookings';

  // Host routes
  static const String hostHome = '/host';
  static const String hostProperties = '/host/properties';
  static const String addProperty = '/host/add-property';
  static const String editProperty = '/host/edit-property/:id';
  static const String hostBookings = '/host/bookings';
  static const String hostEarnings = '/host/earnings';

  // Admin routes
  static const String adminHome = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminProperties = '/admin/properties';
  static const String adminBookings = '/admin/bookings';
  static const String adminReports = '/admin/reports';
}
