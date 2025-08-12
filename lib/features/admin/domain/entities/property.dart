import 'package:equatable/equatable.dart';
import 'package:diar_tunis/features/admin/domain/entities/host.dart';

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
  final String address;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final double area;
  final String type;
  final int maxGuests;
  final int bedrooms;
  final int beds;
  final int bathrooms;
  final double pricePerNight;
  final List<String> amenities;
  final String status;
  final String? hostId;
  final Host? host;
  final DateTime createdAt;
  final List<PropertyImage> images;

  Property({
    required this.id,
    required this.title,
    this.description = '',
    required this.address,
    this.city = '',
    this.state = '',
    this.latitude = 0.0,
    required this.longitude,
    required this.area,
    required this.type,
    required this.maxGuests,
    required this.bedrooms,
    required this.beds,
    required this.bathrooms,
    required this.pricePerNight,
    List<String>? amenities,
    this.status = 'active',
    this.hostId,
    this.host,
    DateTime? createdAt,
    List<PropertyImage>? images,
  }) : amenities = amenities ?? const <String>[],
       images = images ?? const <PropertyImage>[],
       createdAt = createdAt ?? DateTime.now();

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
    address,
    city,
    state,
    latitude,
    longitude,
    area,
    type,
    maxGuests,
    bedrooms,
    beds,
    bathrooms,
    pricePerNight,
    amenities,
    status,
    hostId,
    host,
    createdAt,
    images,
  ];

  Property copyWith({
    String? id,
    String? title,
    String? description,
    String? address,
    String? city,
    String? state,
    double? latitude,
    double? longitude,
    double? area,
    String? type,
    int? maxGuests,
    int? bedrooms,
    int? beds,
    int? bathrooms,
    double? pricePerNight,
    List<String>? amenities,
    String? status,
    String? hostId,
    Host? host,
    DateTime? createdAt,
    List<PropertyImage>? images,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      area: area ?? this.area,
      type: type ?? this.type,
      maxGuests: maxGuests ?? this.maxGuests,
      bedrooms: bedrooms ?? this.bedrooms,
      beds: beds ?? this.beds,
      bathrooms: bathrooms ?? this.bathrooms,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      amenities: amenities ?? this.amenities,
      status: status ?? this.status,
      hostId: hostId ?? this.hostId,
      host: host ?? this.host,
      createdAt: createdAt ?? this.createdAt,
      images: images ?? this.images,
    );
  }
}
