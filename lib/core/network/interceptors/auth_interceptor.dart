import 'package:dio/dio.dart';
import 'package:diar_tunis/core/storage/secure_storage.dart';
import 'package:diar_tunis/core/constants/storage_constants.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage = SecureStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding auth header for auth endpoints
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/register') ||
        options.path.contains('/auth/forgot-password') ||
        options.path.contains('/auth/reset-password')) {
      return handler.next(options);
    }

    // Add auth token to headers
    final token = await _secureStorage.read(StorageConstants.accessToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401) {
      // Clear stored tokens
      _secureStorage.delete(StorageConstants.accessToken);
      _secureStorage.delete(StorageConstants.refreshToken);
      
      // Redirect to login or refresh token
      // This could be handled by the app's navigation system
    }

    handler.next(err);
  }
}
