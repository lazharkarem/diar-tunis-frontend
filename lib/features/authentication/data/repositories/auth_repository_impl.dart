import 'package:dagger/dagger.dart';

import '../../../../core/network/api_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_response_model.dart';

@injectable
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final ApiService _apiService;

  AuthRepositoryImpl(this._remoteDataSource, this._apiService);

  @override
  Future<ApiResponse<User>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String userType,
    String? phone,
    String? address,
    String? businessName,
    String? businessDescription,
    String? licenseNumber,
    int? yearsOfExperience,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        userType: userType,
        phone: phone,
        address: address,
        businessName: businessName,
        businessDescription: businessDescription,
        licenseNumber: licenseNumber,
        yearsOfExperience: yearsOfExperience,
      );

      if (response.isSuccess) {
        // Save token
        await _apiService.saveToken(response.data.accessToken);

        return ApiResponse<User>(
          success: true,
          data: response.data.user.toDomain(),
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
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      if (response.isSuccess) {
        // Save token
        await _apiService.saveToken(response.data.accessToken);

        return ApiResponse<User>(
          success: true,
          data: response.data.user.toDomain(),
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
        message: 'Login failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<User>> getProfile() async {
    try {
      final response = await _remoteDataSource.getProfile();

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
        message: 'Failed to get profile: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<User>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? businessName,
    String? businessDescription,
    String? licenseNumber,
    int? yearsOfExperience,
  }) async {
    try {
      final response = await _remoteDataSource.updateProfile(
        name: name,
        email: email,
        phone: phone,
        address: address,
        businessName: businessName,
        businessDescription: businessDescription,
        licenseNumber: licenseNumber,
        yearsOfExperience: yearsOfExperience,
      );

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
        message: 'Failed to update profile: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (response.isSuccess) {
        // Clear token since user needs to login again
        await _apiService.clearToken();
      }

      return ApiResponse<void>(
        success: response.success,
        message: response.message,
        errors: response.errors,
      );
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Failed to change password: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<void>> logout() async {
    try {
      final response = await _remoteDataSource.logout();

      // Always clear token regardless of API response
      await _apiService.clearToken();

      return ApiResponse<void>(
        success: true,
        message: 'Logged out successfully',
      );
    } catch (e) {
      // Still clear token even if API call fails
      await _apiService.clearToken();

      return ApiResponse<void>(
        success: true,
        message: 'Logged out successfully',
      );
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String?> getStoredToken() async {
    return await _apiService.getToken();
  }

  @override
  Future<void> clearStoredToken() async {
    await _apiService.clearToken();
  }
}
