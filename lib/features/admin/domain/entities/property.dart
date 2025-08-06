import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final double price;
  final List<String> images;
  final String type;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final List<String> amenities;
  final String status;
  final String hostId;
  final DateTime createdAt;

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.images,
    required this.type,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.amenities,
    required this.status,
    required this.hostId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        price,
        images,
        type,
        bedrooms,
        bathrooms,
        area,
        amenities,
        status,
        hostId,
        createdAt,
      ];
}
