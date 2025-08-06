import 'package:equatable/equatable.dart';

class PropertyImage extends Equatable {
  final String imageUrl;
  final bool isPrimary;

  const PropertyImage({required this.imageUrl, this.isPrimary = false});

  @override
  List<Object?> get props => [imageUrl, isPrimary];
}

class Property extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final double price;
  final double pricePerNight;
  final List<PropertyImage> images;
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

  const Property({
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

  PropertyImage? get primaryImage {
    try {
      return images.firstWhere((image) => image.isPrimary);
    } catch (e) {
      return images.isNotEmpty ? images.first : null;
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    location,
    price,
    pricePerNight,
    images,
    type,
    bedrooms,
    bathrooms,
    area,
    amenities,
    status,
    hostId,
    city,
    state,
    createdAt,
  ];
}
