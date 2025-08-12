import 'dart:io';

import 'package:diar_tunis/core/constants/api_constants.dart';
import 'package:diar_tunis/core/constants/storage_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  // Resolve correct base URL by platform (Android emulator needs 10.0.2.2)
  static String get baseUrl {
    try {
      if (Platform.isAndroid) {
        // Use Android emulator loopback
        return 'http://10.0.2.2:8000/api';
      }
    } catch (_) {
      // Platform may not be available (e.g., tests); fallback below
    }
    return ApiConstants.baseUrl;
  }

  late Dio _dio;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request interceptor to add auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized errors
          if (error.response?.statusCode == 401) {
            await clearToken();
            // You might want to navigate to login screen here
          }
          handler.next(error);
        },
      ),
    );

    // Logging interceptor for development
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ),
    );
  }

  // Token management
  Future<String?> getToken() async {
    try {
      // Try common keys for backward compatibility
      final tokenAccess = await _storage.read(key: StorageConstants.accessToken);
      if (tokenAccess != null && tokenAccess.isNotEmpty) return tokenAccess;
      final tokenCached = await _storage.read(key: 'CACHED_TOKEN');
      if (tokenCached != null && tokenCached.isNotEmpty) return tokenCached;
      final tokenLegacy = await _storage.read(key: 'auth_token');
      return tokenLegacy;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    // Write to all known keys to keep systems in sync
    await _storage.write(key: StorageConstants.accessToken, value: token);
    await _storage.write(key: 'CACHED_TOKEN', value: token);
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: StorageConstants.accessToken);
    await _storage.delete(key: 'CACHED_TOKEN');
    await _storage.delete(key: 'auth_token');
  }

  // Generic HTTP methods
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  // File upload
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        if (additionalData != null) ...additionalData,
      });

      final response = await _dio.post(endpoint, data: formData);

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    }
  }

  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final responseData = response.data;
    final statusCode = response.statusCode;
    final headers = response.headers.map;

    if (responseData is Map<String, dynamic>) {
      final success = responseData['success'] ?? false;
      final message = responseData['message'] ?? '';

      if (success) {
        T? data;
        if (fromJson != null && responseData['data'] != null) {
          if (responseData['data'] is Map<String, dynamic>) {
            data = fromJson(responseData['data']);
          } else if (responseData['data'] is List) {
            // Handle list responses
            final list = responseData['data'] as List;
            data = list.map((item) => fromJson(item)).toList() as T;
          }
        } else {
          data = responseData['data'] as T?;
        }

        return ApiResponse<T>(
          success: true, 
          data: data, 
          message: message,
          statusCode: statusCode,
          headers: headers,
        );
      } else {
        return ApiResponse<T>(
          success: false,
          message: message,
          errors: responseData['errors'],
          statusCode: statusCode,
          headers: headers,
        );
      }
    }

    return ApiResponse<T>(
      success: false, 
      message: 'Invalid response format',
      statusCode: statusCode,
      headers: headers,
    );
  }

  ApiResponse<T> _handleError<T>(DioException error) {
    String message = 'An error occurred';
    Map<String, dynamic>? errors;
    int? statusCode;
    Map<String, dynamic>? headers;
    dynamic responseData;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'Connection error. Please check your internet connection.';
    } else if (error.response != null) {
      final response = error.response!;
      statusCode = response.statusCode;
      headers = response.headers.map;
      responseData = response.data;

      // Log the error response for debugging
      print('API Error Response:');
      print('Status Code: $statusCode');
      print('Headers: $headers');
      print('Response Data: $responseData');

      if (responseData is Map<String, dynamic>) {
        message = responseData['message'] ?? 'Server error';
        errors = responseData['errors'];
        
        // Handle common HTTP status codes
        if (statusCode == 401) {
          message = 'Authentication required. Please log in again.';
          // Clear any invalid token
          clearToken();
        } else if (statusCode == 403) {
          message = 'You do not have permission to access this resource.';
        } else if (statusCode == 404) {
          message = 'The requested resource was not found.';
        } else if (statusCode == 500) {
          message = 'An internal server error occurred.';
        }
      } else if (responseData != null) {
        // Handle non-JSON responses (like HTML)
        if (responseData is String && responseData.contains('<!DOCTYPE html>')) {
          message = 'Received HTML response. This usually indicates a server-side error or authentication issue.';
        } else {
          message = 'Unexpected response format: ${responseData.runtimeType}';
        }
      }
    }

    // Log the final error message
    print('Final error message: $message');
    if (errors != null) {
      print('Error details: $errors');
    }

    return ApiResponse<T>(
      success: false, 
      message: message, 
      errors: errors,
      statusCode: statusCode,
      headers: headers,
    );
  }
}

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final Map<String, dynamic>? errors;
  final int? statusCode;
  final Map<String, dynamic>? headers;

  ApiResponse({
    required this.success,
    this.data,
    required this.message,
    this.errors,
    this.statusCode,
    this.headers,
  });

  // Factory constructor for success responses
  factory ApiResponse.success({
    T? data, 
    String message = '',
    int? statusCode,
    Map<String, dynamic>? headers,
  }) {
    return ApiResponse<T>(
      success: true, 
      data: data, 
      message: message,
      statusCode: statusCode,
      headers: headers,
    );
  }

  // Factory constructor for error responses
  factory ApiResponse.error({
    String message = 'An error occurred',
    Map<String, dynamic>? errors,
    int? statusCode,
    Map<String, dynamic>? headers,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
      headers: headers,
    );
  }

  bool get isSuccess => success;
  bool get isError => !success;

  bool get hasData => data != null;
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, hasData: $hasData, hasErrors: $hasErrors)';
  }
}

// Response models for paginated data
class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final dataList = (json['data'] as List)
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    return PaginatedResponse<T>(
      data: dataList,
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      total: json['total'] ?? 0,
      perPage: json['per_page'] ?? 15,
    );
  }

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPreviousPage => currentPage > 1;
  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;
}
