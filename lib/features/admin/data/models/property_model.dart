import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:json_annotation/json_annotation.dart';

part 'property_model.g.dart';

@JsonSerializable()
class PropertyModel extends Property {
  const PropertyModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.price,
    required super.images,
    required super.type,
    required super.bedrooms,
    required super.bathrooms,
    required super.area,
    required super.amenities,
    required super.status,
    required super.hostId,
    required super.createdAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  factory PropertyModel.fromEntity(Property property) {
    return PropertyModel(
      id: property.id,
      title: property.title,
      description: property.description,
      location: property.location,
      price: property.price,
      images: property.images,
      type: property.type,
      bedrooms: property.bedrooms,
      bathrooms: property.bathrooms,
      area: property.area,
      amenities: property.amenities,
      status: property.status,
      hostId: property.hostId,
      createdAt: property.createdAt,
    );
  }
}
