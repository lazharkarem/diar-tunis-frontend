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

// lib/features/shared/data/models/category_model.dart

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final int propertyCount;
  final String icon;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.propertyCount,
    required this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(),
      name: json['name'],
      propertyCount: json['property_count'] ?? json['service_count'] ?? 0,
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'property_count': propertyCount,
      'icon': icon,
    };
  }

  @override
  List<Object?> get props => [id, name, propertyCount, icon];
}
