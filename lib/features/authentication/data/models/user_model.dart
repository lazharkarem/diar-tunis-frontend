import 'package:diar_tunis/features/authentication/domain/entities/user.dart';

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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('=== UserModel.fromJson DEBUG ===');
    print('Input JSON: $json');
    print('JSON keys: ${json.keys.toList()}');
    print('user_type value: ${json['user_type']}');
    print('user_type type: ${json['user_type']?.runtimeType}');
    
    // Handle name field splitting
    final name = json['name'] as String? ?? '';
    final nameParts = name.split(' ');

    final userType = _toUserType(json['user_type']);
    print('Parsed userType: $userType');

    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      firstName: nameParts.isNotEmpty ? nameParts[0] : '',
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      phone: json['phone'] as String? ?? json['phone_number'] as String?,
      avatar: json['avatar'] as String? ?? json['profile_picture'] as String?,
      userType: userType,
      isVerified: json['email_verified_at'] != null,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toString(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] as String? ?? DateTime.now().toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'avatar': avatar,
      'user_type': userType,
      'isVerified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

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

  static String _toIntString(dynamic value) {
    if (value == null) return '';
    if (value is int) return value.toString();
    if (value is String) return value;
    return value.toString();
  }

  static DateTime _toDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.now();
  }

  static String _toUserType(dynamic value) {
    print('=== _toUserType DEBUG ===');
    print('Input value: $value');
    print('Input type: ${value.runtimeType}');
    
    if (value == null) {
      print('Value is null, returning guest');
      return 'guest';
    }
    if (value is String) {
      final result = value.toLowerCase().trim();
      print('Value is String, returning: $result');
      return result;
    }
    final result = value.toString().toLowerCase().trim();
    print('Value converted to String, returning: $result');
    return result;
  }
}
