import 'package:equatable/equatable.dart';

class Destination extends Equatable {
  final String id;
  final String name;
  final String country;
  final String imageUrl;
  final int bookingCount;
  final double avgPrice;
  final String? description;
  final double? latitude;
  final double? longitude;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.imageUrl,
    required this.bookingCount,
    required this.avgPrice,
    this.description,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        country,
        imageUrl,
        bookingCount,
        avgPrice,
        description,
        latitude,
        longitude,
      ];

  Destination copyWith({
    String? id,
    String? name,
    String? country,
    String? imageUrl,
    int? bookingCount,
    double? avgPrice,
    String? description,
    double? latitude,
    double? longitude,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      imageUrl: imageUrl ?? this.imageUrl,
      bookingCount: bookingCount ?? this.bookingCount,
      avgPrice: avgPrice ?? this.avgPrice,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
