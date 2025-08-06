class AppConstants {
  static const String appName = 'Diar Tunis';
  static const String appVersion = '1.0.0';

  // User types
  static const String userTypeGuest = 'guest';
  static const String userTypeHost = 'host';
  static const String userTypeAdmin = 'admin';

  // Booking statuses
  static const String bookingStatusPending = 'pending';
  static const String bookingStatusConfirmed = 'confirmed';
  static const String bookingStatusCancelled = 'cancelled';
  static const String bookingStatusCompleted = 'completed';

  // Property statuses
  static const String propertyStatusPending = 'pending';
  static const String propertyStatusActive = 'active';
  static const String propertyStatusInactive = 'inactive';
  static const String propertyStatusRejected = 'rejected';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Image constraints
  static const int maxImageSizeMB = 5;
  static const int imageQuality = 85;
  static const int thumbnailSize = 300;
}
