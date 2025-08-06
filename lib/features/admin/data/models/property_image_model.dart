import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:json_annotation/json_annotation.dart';

part 'property_image_model.g.dart';

@JsonSerializable()
class PropertyImageModel extends PropertyImage {
  const PropertyImageModel({
    required super.imageUrl,
    super.isPrimary = false,
  });

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyImageModelToJson(this);

  // Convert data model to domain entity
  PropertyImage toDomain() {
    return PropertyImage(
      imageUrl: imageUrl,
      isPrimary: isPrimary,
    );
  }

  factory PropertyImageModel.fromEntity(PropertyImage image) {
    return PropertyImageModel(
      imageUrl: image.imageUrl,
      isPrimary: image.isPrimary,
    );
  }
}
