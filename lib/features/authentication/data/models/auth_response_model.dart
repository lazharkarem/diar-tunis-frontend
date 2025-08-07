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
    return AuthResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: AuthDataModel.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
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
    return AuthDataModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
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
