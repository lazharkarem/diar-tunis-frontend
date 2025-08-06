import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.phone,
    super.avatar,
    required super.userType,
    required super.isVerified,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle Laravel's 'name' field by splitting into firstName and lastName
    final name = json['name'] as String? ?? '';
    final nameParts = name.split(' ');
    
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      firstName: nameParts.isNotEmpty ? nameParts[0] : '',
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      phone: json['phone_number'] as String?,
      avatar: json['profile_picture'] as String?,
      userType: json['user_type'] as String? ?? 'guest',
      isVerified: json['email_verified_at'] != null,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': '$firstName $lastName'.trim(),
      'email': email,
      'phone_number': phone,
      'profile_picture': avatar,
      'user_type': userType,
      'email_verified_at': isVerified ? DateTime.now().toIso8601String() : null,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
      avatar: user.avatar,
      userType: user.userType,
      isVerified: user.isVerified,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}

