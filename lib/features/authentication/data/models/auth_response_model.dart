import 'user_model.dart';

class AuthResponseModel {
  final bool success;
  final String message;
  final AuthDataModel data;

  const AuthResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    print('=== AuthResponseModel.fromJson DEBUG ===');
    print('Input JSON: $json');
    print('JSON keys: ${json.keys.toList()}');
    
    // The API service extracts the 'data' part, so we're receiving the data structure directly
    return AuthResponseModel(
      success: true, // Since we're here, the API call was successful
      message: json['message'] as String? ?? '',
      data: AuthDataModel.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }

  // Convenience getters for backward compatibility
  UserModel get user => data.user;
  String get accessToken => data.accessToken;
  String get tokenType => data.tokenType;
}

class AuthDataModel {
  final UserModel user;
  final String accessToken;
  final String tokenType;

  const AuthDataModel({
    required this.user,
    required this.accessToken,
    required this.tokenType,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    print('=== AuthDataModel.fromJson DEBUG ===');
    print('Input JSON: $json');
    print('JSON keys: ${json.keys.toList()}');
    print('user value: ${json['user']}');
    print('user type: ${json['user']?.runtimeType}');
    
    final userJson = json['user'] as Map<String, dynamic>? ?? {};
    print('userJson: $userJson');
    print('userJson keys: ${userJson.keys.toList()}');
    
    return AuthDataModel(
      user: UserModel.fromJson(userJson),
      accessToken: json['access_token'] as String? ?? '',
      tokenType: json['token_type'] as String? ?? 'Bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      'token_type': tokenType,
    };
  }
}
