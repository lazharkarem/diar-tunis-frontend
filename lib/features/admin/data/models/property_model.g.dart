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
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      images: (json['images'] as List<dynamic>)
          .map((e) => PropertyImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String,
      bedrooms: (json['bedrooms'] as num).toInt(),
      bathrooms: (json['bathrooms'] as num).toInt(),
      area: (json['area'] as num).toDouble(),
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      status: json['status'] as String,
      hostId: json['hostId'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'price': instance.price,
      'pricePerNight': instance.pricePerNight,
      'images': instance.images,
      'type': instance.type,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'area': instance.area,
      'amenities': instance.amenities,
      'status': instance.status,
      'hostId': instance.hostId,
      'city': instance.city,
      'state': instance.state,
      'createdAt': instance.createdAt.toIso8601String(),
    };
