import 'package:equatable/equatable.dart';

class User extends Equatable {
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

  const User({
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

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    phone,
    avatar,
    userType,
    isVerified,
    createdAt,
    updatedAt,
  ];
}
