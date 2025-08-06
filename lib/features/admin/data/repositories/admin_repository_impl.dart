import 'package:diar_tunis/core/network/api_service.dart';
import 'package:diar_tunis/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:diar_tunis/features/admin/domain/entities/admin_statistics.dart';
import 'package:diar_tunis/features/admin/domain/entities/booking.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/admin/domain/repositories/admin_repository.dart';
import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:injectable/injectable.dart';

@injectable
abstract class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource _remoteDataSource;

  AdminRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<PaginatedResponse<User>>> getUsers({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await _remoteDataSource.getUsers(
        page: page,
        perPage: perPage,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<User>(
          data: response.data!.data.map((model) => model.toDomain()).toList(),
          currentPage: response.data!.currentPage,
          lastPage: response.data!.lastPage,
          total: response.data!.total,
          perPage: response.data!.perPage,
        );

        return ApiResponse<PaginatedResponse<User>>(
          success: true,
          data: paginatedResponse,
          message: response.message,
        );
      } else {
        return ApiResponse<PaginatedResponse<User>>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<PaginatedResponse<User>>(
        success: false,
        message: 'Failed to get users: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<User>> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _remoteDataSource.createUser(userData);

      if (response.isSuccess && response.data != null) {
        return ApiResponse<User>(
          success: true,
          data: response.data!.toDomain(),
          message: response.message,
        );
      } else {
        return ApiResponse<User>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: 'Failed to create user: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<User>> updateUser(
    int userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await _remoteDataSource.updateUser(userId, userData);

      if (response.isSuccess && response.data != null) {
        return ApiResponse<User>(
          success: true,
          data: response.data!.toDomain(),
          message: response.message,
        );
      } else {
        return ApiResponse<User>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: 'Failed to update user: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<void>> deleteUser(int userId) async {
    try {
      return await _remoteDataSource.deleteUser(userId);
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Failed to delete user: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<PaginatedResponse<Property>>> getAllProperties({
    int page = 1,
    int perPage = 15,
    String? status,
  }) async {
    try {
      final response = await _remoteDataSource.getAllProperties(
        page: page,
        perPage: perPage,
        status: status,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<Property>(
          data: response.data!.data.map((model) => model.toDomain()).toList(),
          currentPage: response.data!.currentPage,
          lastPage: response.data!.lastPage,
          total: response.data!.total,
          perPage: response.data!.perPage,
        );

        return ApiResponse<PaginatedResponse<Property>>(
          success: true,
          data: paginatedResponse,
          message: response.message,
        );
      } else {
        return ApiResponse<PaginatedResponse<Property>>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<PaginatedResponse<Property>>(
        success: false,
        message: 'Failed to get properties: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<Property>> updatePropertyStatus(
    int propertyId,
    String status,
  ) async {
    try {
      final response = await _remoteDataSource.updatePropertyStatus(
        propertyId,
        status,
      );

      if (response.isSuccess && response.data != null) {
        return ApiResponse<Property>(
          success: true,
          data: response.data!.toDomain(),
          message: response.message,
        );
      } else {
        return ApiResponse<Property>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<Property>(
        success: false,
        message: 'Failed to update property status: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<void>> deleteProperty(int propertyId) async {
    try {
      return await _remoteDataSource.deleteProperty(propertyId);
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Failed to delete property: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<PaginatedResponse<Booking>>> getAllBookings({
    int page = 1,
    int perPage = 15,
    String? status,
  }) async {
    try {
      final response = await _remoteDataSource.getAllBookings(
        page: page,
        perPage: perPage,
        status: status,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<Booking>(
          data: response.data!.data.map((model) => model.toDomain()).toList(),
          currentPage: response.data!.currentPage,
          lastPage: response.data!.lastPage,
          total: response.data!.total,
          perPage: response.data!.perPage,
        );

        return ApiResponse<PaginatedResponse<Booking>>(
          success: true,
          data: paginatedResponse,
          message: response.message,
        );
      } else {
        return ApiResponse<PaginatedResponse<Booking>>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<PaginatedResponse<Booking>>(
        success: false,
        message: 'Failed to get bookings: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<Booking>> updateBookingStatus(
    int bookingId,
    String status,
  ) async {
    try {
      final response = await _remoteDataSource.updateBookingStatus(
        bookingId,
        status,
      );

      if (response.isSuccess && response.data != null) {
        return ApiResponse<Booking>(
          success: true,
          data: response.data!.toDomain(),
          message: response.message,
        );
      } else {
        return ApiResponse<Booking>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<Booking>(
        success: false,
        message: 'Failed to update booking status: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<AdminStatistics>> getStatistics() async {
    try {
      final response = await _remoteDataSource.getStatistics();

      if (response.isSuccess && response.data != null) {
        return ApiResponse<AdminStatistics>(
          success: true,
          data: response.data!.toDomain(),
          message: response.message,
        );
      } else {
        return ApiResponse<AdminStatistics>(
          success: false,
          message: response.message,
          errors: response.errors,
        );
      }
    } catch (e) {
      return ApiResponse<AdminStatistics>(
        success: false,
        message: 'Failed to get statistics: ${e.toString()}',
      );
    }
  }
}
