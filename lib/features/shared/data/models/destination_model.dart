import 'package:diar_tunis/features/shared/domain/entities/destination.dart';
import 'package:equatable/equatable.dart';

class DestinationModel extends Equatable {
  final String id;
  final String name;
  final String country;
  final int bookingCount;
  final double avgPrice;
  final String imageUrl;

  const DestinationModel({
    required this.id,
    required this.name,
    required this.country,
    required this.bookingCount,
    required this.avgPrice,
    required this.imageUrl,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      bookingCount: json['booking_count'] ?? 0,
      avgPrice: (json['avg_price'] as num).toDouble(),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'booking_count': bookingCount,
      'avg_price': avgPrice,
      'image_url': imageUrl,
    };
  }

  Destination toDomain() {
    return Destination(
      id: id,
      name: name,
      country: country,
      bookingCount: bookingCount,
      avgPrice: avgPrice,
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    country,
    bookingCount,
    avgPrice,
    imageUrl,
  ];
}
