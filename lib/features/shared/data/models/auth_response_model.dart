import 'package:diar_tunis/features/shared/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

class AuthResponseModel extends Equatable {
  final UserModel user;
  final String accessToken;
  final String tokenType;

  const AuthResponseModel({
    required this.user,
    required this.accessToken,
    required this.tokenType,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user']),
      accessToken: json['access_token'],
      tokenType: json['token_type'] ?? 'Bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      'token_type': tokenType,
    };
  }

  @override
  List<Object?> get props => [user, accessToken, tokenType];
}
