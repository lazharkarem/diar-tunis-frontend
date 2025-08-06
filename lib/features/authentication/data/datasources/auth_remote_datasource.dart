import '../../../../core/network/api_service.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<AuthResponseModel>> register({
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
  });

  Future<ApiResponse<AuthResponseModel>> login({
    required String email,
    required String password,
  });

  Future<ApiResponse<UserModel>> getProfile();

  Future<ApiResponse<UserModel>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? businessName,
    String? businessDescription,
    String? licenseNumber,
    int? yearsOfExperience,
  });

  Future<ApiResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  Future<ApiResponse<void>> logout();
}

@injectable
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResponse<AuthResponseModel>> register({
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
    final data = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'user_type': userType,
    };

    // Add optional fields
    if (phone != null) data['phone'] = phone;
    if (address != null) data['address'] = address;
    if (businessName != null) data['business_name'] = businessName;
    if (businessDescription != null)
      data['business_description'] = businessDescription;
    if (licenseNumber != null) data['license_number'] = licenseNumber;
    if (yearsOfExperience != null)
      data['years_of_experience'] = yearsOfExperience;

    return await _apiService.post<AuthResponseModel>(
      '/auth/register',
      data: data,
      fromJson: (json) => AuthResponseModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<AuthResponseModel>> login({
    required String email,
    required String password,
  }) async {
    return await _apiService.post<AuthResponseModel>(
      '/auth/login',
      data: {'email': email, 'password': password},
      fromJson: (json) => AuthResponseModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<UserModel>> getProfile() async {
    return await _apiService.get<UserModel>(
      '/auth/profile',
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<UserModel>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? businessName,
    String? businessDescription,
    String? licenseNumber,
    int? yearsOfExperience,
  }) async {
    final data = <String, dynamic>{};

    // Only add non-null fields
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (address != null) data['address'] = address;
    if (businessName != null) data['business_name'] = businessName;
    if (businessDescription != null)
      data['business_description'] = businessDescription;
    if (licenseNumber != null) data['license_number'] = licenseNumber;
    if (yearsOfExperience != null)
      data['years_of_experience'] = yearsOfExperience;

    return await _apiService.put<UserModel>(
      '/auth/profile',
      data: data,
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await _apiService.post<void>(
      '/auth/change-password',
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      },
    );
  }

  @override
  Future<ApiResponse<void>> logout() async {
    return await _apiService.post<void>('/auth/logout');
  }
}
