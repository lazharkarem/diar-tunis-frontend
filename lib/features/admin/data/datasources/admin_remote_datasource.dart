import 'package:diar_tunis/features/admin/data/models/admin_statistics_model.dart';
import 'package:diar_tunis/features/admin/data/models/property_model.dart';
import 'package:diar_tunis/features/shared/data/models/booking_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_service.dart';
import '../../../shared/data/models/user_model.dart';

abstract class AdminRemoteDataSource {
  // User Management
  Future<ApiResponse<PaginatedResponse<UserModel>>> getUsers({
    int page = 1,
    int perPage = 15,
  });
  Future<ApiResponse<UserModel>> createUser(Map<String, dynamic> userData);
  Future<ApiResponse<UserModel>> updateUser(
    int userId,
    Map<String, dynamic> userData,
  );
  Future<ApiResponse<void>> deleteUser(int userId);

  // Property Management
  Future<ApiResponse<PaginatedResponse<PropertyModel>>> getAllProperties({
    int page = 1,
    int perPage = 15,
    String? status,
  });
  Future<ApiResponse<PropertyModel>> updatePropertyStatus(
    int propertyId,
    String status,
  );
  Future<ApiResponse<void>> deleteProperty(int propertyId);

  // Booking Management
  Future<ApiResponse<PaginatedResponse<BookingModel>>> getAllBookings({
    int page = 1,
    int perPage = 15,
    String? status,
  });
  Future<ApiResponse<BookingModel>> updateBookingStatus(
    int bookingId,
    String status,
  );

  // Statistics
  Future<ApiResponse<AdminStatisticsModel>> getStatistics();
}

@injectable
class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final ApiService _apiService;

  AdminRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResponse<PaginatedResponse<UserModel>>> getUsers({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/admin/users',
      queryParameters: {'page': page, 'per_page': perPage},
    );

    if (response.isSuccess && response.data != null) {
      final paginatedResponse = PaginatedResponse.fromJson(
        response.data!,
        (json) => UserModel.fromJson(json),
      );

      return ApiResponse<PaginatedResponse<UserModel>>(
        success: true,
        data: paginatedResponse,
        message: response.message,
      );
    } else {
      return ApiResponse<PaginatedResponse<UserModel>>(
        success: false,
        message: response.message,
        errors: response.errors,
      );
    }
  }

  @override
  Future<ApiResponse<UserModel>> createUser(
    Map<String, dynamic> userData,
  ) async {
    return await _apiService.post<UserModel>(
      '/admin/users',
      data: userData,
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<UserModel>> updateUser(
    int userId,
    Map<String, dynamic> userData,
  ) async {
    return await _apiService.put<UserModel>(
      '/admin/users/$userId',
      data: userData,
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<void>> deleteUser(int userId) async {
    return await _apiService.delete<void>('/admin/users/$userId');
  }

  @override
  Future<ApiResponse<PaginatedResponse<PropertyModel>>> getAllProperties({
    int page = 1,
    int perPage = 15,
    String? status,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (status != null && status.isNotEmpty) {
      queryParameters['status'] = status;
    }

    final response = await _apiService.get<Map<String, dynamic>>(
      '/admin/properties',
      queryParameters: queryParameters,
    );

    if (response.isSuccess && response.data != null) {
      final paginatedResponse = PaginatedResponse.fromJson(
        response.data!,
        (json) => PropertyModel.fromJson(json),
      );

      return ApiResponse<PaginatedResponse<PropertyModel>>(
        success: true,
        data: paginatedResponse,
        message: response.message,
      );
    } else {
      return ApiResponse<PaginatedResponse<PropertyModel>>(
        success: false,
        message: response.message,
        errors: response.errors,
      );
    }
  }

  @override
  Future<ApiResponse<PropertyModel>> updatePropertyStatus(
    int propertyId,
    String status,
  ) async {
    return await _apiService.put<PropertyModel>(
      '/admin/properties/$propertyId/status',
      data: {'status': status},
      fromJson: (json) => PropertyModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<void>> deleteProperty(int propertyId) async {
    return await _apiService.delete<void>('/admin/properties/$propertyId');
  }

  @override
  Future<ApiResponse<PaginatedResponse<BookingModel>>> getAllBookings({
    int page = 1,
    int perPage = 15,
    String? status,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (status != null && status.isNotEmpty) {
      queryParameters['status'] = status;
    }

    final response = await _apiService.get<Map<String, dynamic>>(
      '/admin/bookings',
      queryParameters: queryParameters,
    );

    if (response.isSuccess && response.data != null) {
      final paginatedResponse = PaginatedResponse.fromJson(
        response.data!,
        (json) => BookingModel.fromJson(json),
      );

      return ApiResponse<PaginatedResponse<BookingModel>>(
        success: true,
        data: paginatedResponse,
        message: response.message,
      );
    } else {
      return ApiResponse<PaginatedResponse<BookingModel>>(
        success: false,
        message: response.message,
        errors: response.errors,
      );
    }
  }

  @override
  Future<ApiResponse<BookingModel>> updateBookingStatus(
    int bookingId,
    String status,
  ) async {
    return await _apiService.put<BookingModel>(
      '/admin/bookings/$bookingId/status',
      data: {'status': status},
      fromJson: (json) => BookingModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<AdminStatisticsModel>> getStatistics() async {
    return await _apiService.get<AdminStatisticsModel>(
      '/admin/statistics',
      fromJson: (json) => AdminStatisticsModel.fromJson(json),
    );
  }
}
