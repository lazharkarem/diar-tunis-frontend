import 'package:diar_tunis/features/admin/domain/entities/property.dart';
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

  String? get thumbnailUrl {
    if (images.isEmpty) return null;

    // First try to find a thumbnail
    final thumbnail = images.firstWhere(
      (img) => img.isThumbnail || img.isPrimary,
      orElse: () => images.first,
    );

    return thumbnail.imageUrl;
  }

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
     // Parse images
    final images =
        (json['images'] as List<dynamic>?)
            ?.map(
              (img) => PropertyImageModel.fromJson(
                img is Map<String, dynamic>
                    ? img
                    : {
                        'image_url': img,
                      }, // Handle case where images is a list of strings
              ),
            )
            .toList() ??
        [];
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
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      host: json['host'] != null
          ? UserModel.fromJson(
              json['host'] is Map<String, dynamic> ? json['host'] : {},
            )
          : null,
      amenities:
          (json['amenities'] as List<dynamic>?)
              ?.map((a) => PropertyAmenityModel.fromJson(a))
              .toList() ??
          [],
      images: images,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
          : DateTime.now(),
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

  Property toDomain() {
    return Property(
      id: id.toString(),
      title: title,
      description: description,
      address: address,
      city: city,
      state: state,
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
      area: 0.0, // Model doesn't have area, default to 0.0
      type: type,
      maxGuests: maxGuests,
      bedrooms: 0, // Model doesn't have bedrooms, default to 0
      beds: 0, // Model doesn't have beds, default to 0
      bathrooms: 0, // Model doesn't have bathrooms, default to 0
      pricePerNight: pricePerNight,
      amenities: amenities.map((a) => a.name).toList(),
      status: status,
      hostId: host?.id.toString(),
      host: null, // Host entity conversion can be added if needed
      createdAt: createdAt,
      images: images.map((i) => i.toDomain()).toList(),
    );
  }

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
  final bool isThumbnail;

  const PropertyImageModel({
    required this.id,
    required this.propertyId,
    required this.imageUrl,
    required this.isPrimary,
     this.isThumbnail = false,
  });

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
    return PropertyImageModel(
      id: json['id'] as int? ?? 0,
      propertyId: json['property_id'] as int? ?? 0,
      imageUrl: _parseImageUrl(json),
      isPrimary: json['is_primary'] == true || json['is_primary'] == 1,
      isThumbnail: json['is_thumbnail'] == true || json['is_thumbnail'] == 1,
    );
  }


    // Helper method to parse image URL from different formats
  static String _parseImageUrl(Map<String, dynamic> json) {
    final imageUrl = json['image_url'];
    if (imageUrl is String) {
      return imageUrl;
    }
    return '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'image_url': imageUrl,
      'is_primary': isPrimary,
      'is_thumbnail': isThumbnail,
    };
  }

  PropertyImage toDomain() {
    return PropertyImage(
      imageUrl: imageUrl,
      isPrimary: isPrimary,
    );
  }

  @override
  List<Object?> get props => [id, propertyId, imageUrl, isPrimary, isThumbnail];
}
