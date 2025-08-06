// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyImageModel _$PropertyImageModelFromJson(Map<String, dynamic> json) =>
    PropertyImageModel(
      imageUrl: json['imageUrl'] as String,
      isPrimary: json['isPrimary'] as bool? ?? false,
    );

Map<String, dynamic> _$PropertyImageModelToJson(PropertyImageModel instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'isPrimary': instance.isPrimary,
    };
