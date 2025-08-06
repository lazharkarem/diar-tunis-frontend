import 'package:diar_tunis/features/authentication/domain/entities/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? avatar;
  final String userType;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.avatar,
    required this.userType,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to domain entity
  User toDomain() {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      avatar: avatar,
      userType: userType,
      isVerified: isVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convert from domain entity
  factory UserModel.fromDomain(User user) {
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

  // JSON serialization
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
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now(),
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
