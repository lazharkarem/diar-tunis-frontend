// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      id: json['id'] == null ? '' : _toString(json['id']),
      title: json['title'] == null ? '' : _toString(json['title']),
      description:
          json['description'] == null ? '' : _toString(json['description']),
      address: json['address'] == null ? '' : _toString(json['address']),
      city: json['city'] == null ? '' : _toString(json['city']),
      state: json['state'] == null ? '' : _toString(json['state']),
      latitude: json['latitude'] == null ? 0.0 : _toDouble(json['latitude']),
      longitude: json['longitude'] == null ? 0.0 : _toDouble(json['longitude']),
      area: json['area'] == null ? 0.0 : _toDouble(json['area']),
      type: json['property_type'] as String? ?? 'apartment',
      maxGuests: json['number_of_guests'] == null
          ? 1
          : _toInt(json['number_of_guests']),
      bedrooms: json['number_of_bedrooms'] == null
          ? 1
          : _toInt(json['number_of_bedrooms']),
      beds: json['number_of_beds'] == null ? 1 : _toInt(json['number_of_beds']),
      bathrooms: json['number_of_bathrooms'] == null
          ? 1
          : _toInt(json['number_of_bathrooms']),
      pricePerNight: json['price_per_night'] == null
          ? 0.0
          : _toDouble(json['price_per_night']),
      amenities:
          json['amenities'] == null ? [] : _toStringList(json['amenities']),
      status: json['status'] == null ? 'active' : _toString(json['status']),
      host: json['host'] == null
          ? null
          : HostModel.fromJson(json['host'] as Map<String, dynamic>),
      createdAt: _dateTimeFromJson(json['created_at']),
      images:
          json['images'] == null ? [] : _toPropertyImageList(json['images']),
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'area': instance.area,
      'property_type': instance.type,
      'number_of_guests': instance.maxGuests,
      'number_of_bedrooms': instance.bedrooms,
      'number_of_beds': instance.beds,
      'number_of_bathrooms': instance.bathrooms,
      'price_per_night': instance.pricePerNight,
      'amenities': instance.amenities,
      'status': instance.status,
      'host': instance.host,
      'created_at': instance.createdAt?.toIso8601String(),
      'images': instance.images,
    };
