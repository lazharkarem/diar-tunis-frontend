class ApiConstants {
  // Update this to your Laravel backend URL
  static const String baseUrl = 'http://10.0.0.189:8000/api';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String userProfileEndpoint = '/auth/profile';

  // Property endpoints
  static const String propertiesEndpoint = '/properties';

  // Guest booking endpoints
  static const String guestBookingsEndpoint = '/guest/bookings';

  // Admin endpoints
  static const String adminUsersEndpoint = '/admin/users';
  static const String adminPropertiesEndpoint = '/admin/properties';
  static const String adminBookingsEndpoint = '/admin/bookings';
  static const String adminStatsEndpoint = '/admin/statistics';

  // Request timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}
