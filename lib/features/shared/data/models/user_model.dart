import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String userType;
  final bool isActive;
  final UserProfileModel? profile;
  final ServiceProviderModel? serviceProvider;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.isActive,
    this.profile,
    this.serviceProvider,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: json['user_type'],
      isActive: json['is_active'] ?? true,
      profile: json['profile'] != null
          ? UserProfileModel.fromJson(json['profile'])
          : null,
      serviceProvider: json['service_provider'] != null
          ? ServiceProviderModel.fromJson(json['service_provider'])
          : null,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'user_type': userType,
      'is_active': isActive,
      'profile': profile?.toJson(),
      'service_provider': serviceProvider?.toJson(),
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isGuest => userType == 'guest';
  bool get isHost => userType == 'host';
  bool get isServiceCustomer => userType == 'service_customer';
  bool get isServiceProvider => userType == 'service_provider';
  bool get isAdmin => userType == 'admin';

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    userType,
    isActive,
    profile,
    serviceProvider,
    emailVerifiedAt,
    createdAt,
    updatedAt,
  ];
}

class UserProfileModel extends Equatable {
  final int id;
  final int userId;
  final String? phone;
  final String? address;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfileModel({
    required this.id,
    required this.userId,
    this.phone,
    this.address,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      userId: json['user_id'],
      phone: json['phone'],
      address: json['address'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone': phone,
      'address': address,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    phone,
    address,
    avatar,
    createdAt,
    updatedAt,
  ];
}

class ServiceProviderModel extends Equatable {
  final int id;
  final int userId;
  final String businessName;
  final String businessDescription;
  final String? licenseNumber;
  final int yearsOfExperience;
  final String verificationStatus;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceProviderModel({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.businessDescription,
    this.licenseNumber,
    required this.yearsOfExperience,
    required this.verificationStatus,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderModel(
      id: json['id'],
      userId: json['user_id'],
      businessName: json['business_name'],
      businessDescription: json['business_description'],
      licenseNumber: json['license_number'],
      yearsOfExperience: json['years_of_experience'] ?? 0,
      verificationStatus: json['verification_status'],
      isAvailable: json['is_available'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'business_name': businessName,
      'business_description': businessDescription,
      'license_number': licenseNumber,
      'years_of_experience': yearsOfExperience,
      'verification_status': verificationStatus,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isPending => verificationStatus == 'pending';
  bool get isVerified => verificationStatus == 'verified';
  bool get isRejected => verificationStatus == 'rejected';
  bool get isSuspended => verificationStatus == 'suspended';

  @override
  List<Object?> get props => [
    id,
    userId,
    businessName,
    businessDescription,
    licenseNumber,
    yearsOfExperience,
    verificationStatus,
    isAvailable,
    createdAt,
    updatedAt,
  ];
}
