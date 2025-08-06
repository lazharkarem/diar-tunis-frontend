import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/admin/data/models/property_image_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'property_model.g.dart';

@JsonSerializable()
class PropertyModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final double price;
  final double pricePerNight;
  final List<PropertyImageModel> images;
  final String type;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final List<String> amenities;
  final String status;
  final String hostId;
  final String city;
  final String state;
  final DateTime createdAt;

  const PropertyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.pricePerNight,
    required this.images,
    required this.type,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.amenities,
    required this.status,
    required this.hostId,
    required this.city,
    required this.state,
    required this.createdAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  // Convert data model to domain entity
  Property toDomain() {
    return Property(
      id: id,
      title: title,
      description: description,
      location: location,
      price: price,
      images: images.map((image) => image.toDomain()).toList(),
      type: type,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      area: area,
      amenities: amenities,
      status: status,
      hostId: hostId,
      pricePerNight: pricePerNight,
      city: city,
      state: state,
      createdAt: createdAt,
    );
  }

  factory PropertyModel.fromEntity(Property property) {
    return PropertyModel(
      id: property.id,
      title: property.title,
      description: property.description,
      location: property.location,
      price: property.price,
      images: property.images.map((image) => PropertyImageModel.fromEntity(image)).toList(),
      type: property.type,
      bedrooms: property.bedrooms,
      bathrooms: property.bathrooms,
      area: property.area,
      amenities: property.amenities,
      status: property.status,
      hostId: property.hostId,
      pricePerNight: property.pricePerNight,
      city: property.city,
      state: property.state,
      createdAt: property.createdAt,
    );
  }
}
