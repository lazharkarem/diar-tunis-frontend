// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      price: (json['price'] as num).toDouble(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      type: json['type'] as String,
      bedrooms: (json['bedrooms'] as num).toInt(),
      bathrooms: (json['bathrooms'] as num).toInt(),
      area: (json['area'] as num).toDouble(),
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      status: json['status'] as String,
      hostId: json['hostId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'price': instance.price,
      'images': instance.images,
      'type': instance.type,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'area': instance.area,
      'amenities': instance.amenities,
      'status': instance.status,
      'hostId': instance.hostId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
