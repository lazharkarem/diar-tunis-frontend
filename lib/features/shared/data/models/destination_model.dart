import 'package:equatable/equatable.dart';

class DestinationModel extends Equatable {
  final String name;
  final String country;
  final int bookingCount;
  final double avgPrice;
  final String imageUrl;

  const DestinationModel({
    required this.name,
    required this.country,
    required this.bookingCount,
    required this.avgPrice,
    required this.imageUrl,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      name: json['name'],
      country: json['country'],
      bookingCount: json['booking_count'] ?? 0,
      avgPrice: (json['avg_price'] as num).toDouble(),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'booking_count': bookingCount,
      'avg_price': avgPrice,
      'image_url': imageUrl,
    };
  }

  @override
  List<Object?> get props => [name, country, bookingCount, avgPrice, imageUrl];
}
