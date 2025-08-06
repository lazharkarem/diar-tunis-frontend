import 'package:diar_tunis/core/errors/exceptions.dart';
import 'package:diar_tunis/features/admin/data/models/property_model.dart';
import 'package:diar_tunis/features/authentication/data/models/user_model.dart';
import 'package:dio/dio.dart';

abstract class AdminRemoteDataSource {
  // Users Management
  Future<List<UserModel>> getAllUsers();
  Future<UserModel> updateUserStatus(String userId, String status);
  Future<UserModel> createUser(Map<String, dynamic> userData);
  Future<UserModel> updateUser(String userId, Map<String, dynamic> userData);
  Future<void> deleteUser(String userId);

  // Properties Management
  Future<List<PropertyModel>> getAllProperties();
  Future<PropertyModel> updatePropertyStatus(String propertyId, String status);
  Future<PropertyModel> createProperty(Map<String, dynamic> propertyData);
  Future<PropertyModel> updateProperty(
    String propertyId,
    Map<String, dynamic> propertyData,
  );
  Future<void> deleteProperty(String propertyId);

  // Bookings Management
  Future<List<Map<String, dynamic>>> getAllBookings();
  Future<Map<String, dynamic>> updateBookingStatus(
    String bookingId,
    String status,
  );
  Future<void> cancelBooking(String bookingId);

  // Experiences Management
  Future<List<Map<String, dynamic>>> getAllExperiences();
  Future<Map<String, dynamic>> updateExperienceStatus(
    String experienceId,
    String status,
  );

  // Payments Management
  Future<List<Map<String, dynamic>>> getAllPayments();
  Future<Map<String, dynamic>> updatePaymentStatus(
    String paymentId,
    String status,
  );

  // Service Providers Management
  Future<List<Map<String, dynamic>>> getAllServiceProviders();
  Future<Map<String, dynamic>> updateServiceProviderStatus(
    String providerId,
    String status,
  );

  // Statistics & Dashboard
  Future<Map<String, dynamic>> getDashboardStats();
  Future<List<Map<String, dynamic>>> getRecentActivities();
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PropertyModel>> getAllProperties() async {
    try {
      final response = await dio.get('/admin/properties');
      final List<dynamic> jsonResponse = response.data;
      return jsonResponse.map((json) => PropertyModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to load properties: ${e.message}');
    }
  }

  @override
  Future<PropertyModel> updatePropertyStatus(
    String propertyId,
    String status,
  ) async {
    try {
      final response = await dio.put(
        '/admin/properties/$propertyId/status',
        data: {'status': status},
      );
      return PropertyModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: 'Failed to update property status: ${e.message}',
      );
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await dio.get('/admin/users');
      final List<dynamic> jsonResponse = response.data;
      return jsonResponse.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to load users: ${e.message}');
    }
  }

  @override
  Future<UserModel> updateUserStatus(String userId, String status) async {
    try {
      final response = await dio.put(
        '/admin/users/$userId/status',
        data: {'status': status},
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to update user status: ${e.message}');
    }
  }

  @override
  Future<UserModel> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await dio.post('/admin/users', data: userData);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to create user: ${e.message}');
    }
  }

  @override
  Future<UserModel> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      final response = await dio.put('/admin/users/$userId', data: userData);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to update user: ${e.message}');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await dio.delete('/admin/users/$userId');
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to delete user: ${e.message}');
    }
  }

  @override
  Future<PropertyModel> createProperty(Map<String, dynamic> propertyData) async {
    try {
      final response = await dio.post('/admin/properties', data: propertyData);
      return PropertyModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to create property: ${e.message}');
    }
  }

  @override
  Future<PropertyModel> updateProperty(String propertyId, Map<String, dynamic> propertyData) async {
    try {
      final response = await dio.put('/admin/properties/$propertyId', data: propertyData);
      return PropertyModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to update property: ${e.message}');
    }
  }

  @override
  Future<void> deleteProperty(String propertyId) async {
    try {
      await dio.delete('/admin/properties/$propertyId');
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to delete property: ${e.message}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllBookings() async {
    try {
      final response = await dio.get('/admin/bookings');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to load bookings: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> updateBookingStatus(String bookingId, String status) async {
    try {
      final response = await dio.put(
        '/admin/bookings/$bookingId/status',
        data: {'status': status},
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to update booking status: ${e.message}');
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await dio.put(
        '/admin/bookings/$bookingId/cancel',
      );
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to cancel booking: ${e.message}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllExperiences() async {
    try {
      final response = await dio.get('/admin/experiences');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to load experiences: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> updateExperienceStatus(String experienceId, String status) async {
    try {
      final response = await dio.put(
        '/admin/experiences/$experienceId/status',
        data: {'status': status},
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to update experience status: ${e.message}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllPayments() async {
    try {
      final response = await dio.get('/admin/payments');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to load payments: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> updatePaymentStatus(String paymentId, String status) async {
    try {
      final response = await dio.put(
        '/admin/payments/$paymentId/status',
        data: {'status': status},
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to update payment status: ${e.message}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllServiceProviders() async {
    try {
      final response = await dio.get('/admin/service-providers');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to load service providers: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> updateServiceProviderStatus(String providerId, String status) async {
    try {
      final response = await dio.put(
        '/admin/service-providers/$providerId/status',
        data: {'status': status},
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to update service provider status: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await dio.get('/admin/dashboard/stats');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to load dashboard stats: ${e.message}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRecentActivities() async {
    try {
      final response = await dio.get('/admin/dashboard/activities');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to load recent activities: ${e.message}');
    }
  }
}
