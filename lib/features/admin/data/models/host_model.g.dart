// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HostModel _$HostModelFromJson(Map<String, dynamic> json) => HostModel(
      id: _toString(json['id']),
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      profilePicture: json['profile_picture'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$HostModelToJson(HostModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'profile_picture': instance.profilePicture,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
    };
