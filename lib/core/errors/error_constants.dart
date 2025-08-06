class ErrorConstants {
  // Network errors
  static const String networkError = 'Network connection failed';
  static const String timeoutError = 'Request timeout';
  static const String serverError = 'Server error occurred';

  // Authentication errors
  static const String invalidCredentials = 'Invalid email or password';
  static const String userNotFound = 'User not found';
  static const String emailAlreadyExists = 'Email already exists';
  static const String weakPassword = 'Password is too weak';

  // Validation errors
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String passwordMismatch = 'Passwords do not match';

  // General errors
  static const String unknownError = 'An unknown error occurred';
  static const String permissionDenied = 'Permission denied';
  static const String notFound = 'Resource not found';
}
