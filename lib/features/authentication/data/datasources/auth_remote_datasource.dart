import 'package:dio/dio.dart';
import 'package:diar_tunis/core/errors/exceptions.dart';
import 'package:diar_tunis/core/constants/api_constants.dart';
import 'package:diar_tunis/features/authentication/data/models/auth_response_model.dart';
import 'package:diar_tunis/features/authentication/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  });
  Future<UserModel> getUserProfile();
  Future<void> logout();
  Future<AuthResponseModel> refreshToken();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String password);
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? avatar,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Login failed: ${e.response?.data?['message'] ?? e.message}');
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}/auth/register',
        data: {
          'email': email,
          'password': password,
          'password_confirmation': password,
          'name': name,
          'phone': phone,
          'user_type': 'guest', // Default user type
        },
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Registration failed: ${e.response?.data?['message'] ?? e.message}');
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await dio.get('${ApiConstants.baseUrl}/auth/profile');
      final data = response.data['data'] ?? response.data;
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(message: 'Failed to get user profile: ${e.response?.data?['message'] ?? e.message}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('${ApiConstants.baseUrl}/auth/logout');
    } on DioException catch (e) {
      throw ServerException(message: 'Logout failed: ${e.response?.data?['message'] ?? e.message}');
    }
  }

  @override
  Future<AuthResponseModel> refreshToken() async {
    try {
      final response = await dio.post('/auth/refresh');
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Token refresh failed: ${e.message}');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await dio.post('/auth/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      throw ServerException(message: 'Forgot password failed: ${e.message}');
    }
  }

  @override
  Future<void> resetPassword(String token, String password) async {
    try {
      await dio.post('/auth/reset-password', data: {
        'token': token,
        'password': password,
      });
    } on DioException catch (e) {
      throw ServerException(message: 'Reset password failed: ${e.message}');
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? avatar,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'firstName': firstName,
        'lastName': lastName,
      };
      if (phone != null) data['phone'] = phone;
      if (avatar != null) data['avatar'] = avatar;
      
      final response = await dio.put('/auth/profile', data: data);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: 'Profile update failed: ${e.message}');
    }
  }
}
