import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/admin/data/models/property_image_model.dart';
import 'package:diar_tunis/features/admin/data/models/host_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'property_model.g.dart';

// Helper to safely parse numbers from string or num
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

// Helper to safely parse integers from string or num
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

// Helper to safely parse string from dynamic value
String _toString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

// Helper to safely parse a list of strings
List<String> _toStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map((e) => _toString(e)).where((e) => e.isNotEmpty).toList();
  }
  return [];
}

// Helper to safely parse a list of PropertyImageModel
List<PropertyImageModel> _toPropertyImageList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map<PropertyImageModel>((e) {
      try {
        if (e is Map<String, dynamic>) {
          return PropertyImageModel.fromJson(e);
        }
        return PropertyImageModel(imageUrl: _toString(e));
      } catch (_) {
        return PropertyImageModel(imageUrl: _toString(e));
      }
    }).toList();
  }
  return [];
}

// Helper to parse DateTime from JSON
DateTime? _dateTimeFromJson(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}

@JsonSerializable()
class PropertyModel {
  @JsonKey(name: 'id', fromJson: _toString, defaultValue: '')
  final String id;
  
  @JsonKey(name: 'title', fromJson: _toString, defaultValue: '')
  final String title;
  
  @JsonKey(name: 'description', fromJson: _toString, defaultValue: '')
  final String description;
  
  @JsonKey(name: 'address', fromJson: _toString, defaultValue: '')
  final String address;
  
  @JsonKey(name: 'city', fromJson: _toString, defaultValue: '')
  final String city;
  
  @JsonKey(name: 'state', fromJson: _toString, defaultValue: '')
  final String state;
  
  @JsonKey(name: 'latitude', fromJson: _toDouble, defaultValue: 0.0)
  final double latitude;
  
  @JsonKey(name: 'longitude', fromJson: _toDouble, defaultValue: 0.0)
  final double longitude;
  
  @JsonKey(name: 'area', fromJson: _toDouble, defaultValue: 0.0)
  final double area;
  
  @JsonKey(name: 'property_type', defaultValue: 'apartment')
  final String type;
  
  @JsonKey(name: 'number_of_guests', fromJson: _toInt, defaultValue: 1)
  final int maxGuests;
  
  @JsonKey(name: 'number_of_bedrooms', fromJson: _toInt, defaultValue: 1)
  final int bedrooms;
  
  @JsonKey(name: 'number_of_beds', fromJson: _toInt, defaultValue: 1)
  final int beds;
  
  @JsonKey(name: 'number_of_bathrooms', fromJson: _toInt, defaultValue: 1)
  final int bathrooms;
  
  @JsonKey(name: 'price_per_night', fromJson: _toDouble, defaultValue: 0.0)
  final double pricePerNight;
  
  @JsonKey(fromJson: _toStringList, defaultValue: <String>[])
  final List<String> amenities;
  
  @JsonKey(fromJson: _toString, defaultValue: 'active')
  final String status;
  
  @JsonKey(name: 'host')
  final HostModel? host;
  
  @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
  final DateTime? createdAt;
  
  @JsonKey(name: 'images', fromJson: _toPropertyImageList, defaultValue: <PropertyImageModel>[])
  final List<PropertyImageModel> images;
  
  // City and state are derived from address

  const PropertyModel({
    this.id = '',
    this.title = '',
    this.description = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.area = 0.0,
    this.type = 'apartment',
    this.maxGuests = 1,
    this.bedrooms = 1,
    this.beds = 1,
    this.bathrooms = 1,
    this.pricePerNight = 0.0,
    this.amenities = const <String>[],
    this.status = 'active',
    this.host,
    this.createdAt,
    this.images = const <PropertyImageModel>[],
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);
  
  // Convert data model to domain entity
  Property toEntity() {
    return Property(
      id: id,
      title: title,
      description: description,
      address: address,
      city: city,
      state: state,
      latitude: latitude,
      longitude: longitude,
      area: area,
      type: type,
      maxGuests: maxGuests,
      bedrooms: bedrooms,
      beds: beds,
      bathrooms: bathrooms,
      pricePerNight: pricePerNight,
      amenities: amenities,
      status: status,
      hostId: host?.id,
      host: host?.toEntity(),
      createdAt: createdAt,
      images: images.map((e) => e.toEntity()).toList(),
    );
  }
  
  // Alias for backward compatibility with existing code
  Property toDomain() => toEntity();

  factory PropertyModel.fromEntity(Property property) {
    return PropertyModel(
      id: property.id,
      title: property.title,
      description: property.description,
      address: property.address,
      latitude: property.latitude,
      longitude: property.longitude,
      type: property.type,
      maxGuests: property.maxGuests,
      bedrooms: property.bedrooms,
      beds: property.beds,
      bathrooms: property.bathrooms,
      pricePerNight: property.pricePerNight,
      amenities: property.amenities,
      status: property.status,
      host: property.host != null ? HostModel.fromEntity(property.host!) : null,
      createdAt: property.createdAt,
      images: property.images.map((image) => PropertyImageModel.fromEntity(image)).toList(),
    );
  }


}
