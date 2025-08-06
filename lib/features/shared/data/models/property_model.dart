import 'package:diar_tunis/features/shared/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

class PropertyModel extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String type;
  final double pricePerNight;
  final int maxGuests;
  final String address;
  final String city;
  final String state;
  final String country;
  final double? latitude;
  final double? longitude;
  final String status;
  final bool isFeatured;
  final UserModel? host;
  final List<PropertyAmenityModel> amenities;
  final List<PropertyImageModel> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PropertyModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.pricePerNight,
    required this.maxGuests,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    this.latitude,
    this.longitude,
    required this.status,
    required this.isFeatured,
    this.host,
    required this.amenities,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      pricePerNight: (json['price_per_night'] as num).toDouble(),
      maxGuests: json['max_guests'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      status: json['status'],
      isFeatured: json['is_featured'] ?? false,
      host: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      amenities:
          (json['amenities'] as List<dynamic>?)
              ?.map((amenity) => PropertyAmenityModel.fromJson(amenity))
              .toList() ??
          [],
      images:
          (json['images'] as List<dynamic>?)
              ?.map((image) => PropertyImageModel.fromJson(image))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'type': type,
      'price_per_night': pricePerNight,
      'max_guests': maxGuests,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'is_featured': isFeatured,
      'user': host?.toJson(),
      'amenities': amenities.map((a) => a.toJson()).toList(),
      'images': images.map((i) => i.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PropertyImageModel? get primaryImage =>
      images.firstWhere((img) => img.isPrimary, orElse: () => images.first);

  String get fullAddress => '$address, $city, $state, $country';

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isSuspended => status == 'suspended';

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    description,
    type,
    pricePerNight,
    maxGuests,
    address,
    city,
    state,
    country,
    latitude,
    longitude,
    status,
    isFeatured,
    host,
    amenities,
    images,
    createdAt,
    updatedAt,
  ];
}

class PropertyAmenityModel extends Equatable {
  final int id;
  final String name;

  const PropertyAmenityModel({required this.id, required this.name});

  factory PropertyAmenityModel.fromJson(Map<String, dynamic> json) {
    return PropertyAmenityModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  List<Object?> get props => [id, name];
}

class PropertyImageModel extends Equatable {
  final int id;
  final int propertyId;
  final String imageUrl;
  final bool isPrimary;

  const PropertyImageModel({
    required this.id,
    required this.propertyId,
    required this.imageUrl,
    required this.isPrimary,
  });

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
    return PropertyImageModel(
      id: json['id'],
      propertyId: json['property_id'],
      imageUrl: json['image_url'],
      isPrimary: json['is_primary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'image_url': imageUrl,
      'is_primary': isPrimary,
    };
  }

  @override
  List<Object?> get props => [id, propertyId, imageUrl, isPrimary];
}
