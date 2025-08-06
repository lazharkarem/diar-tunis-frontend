import 'package:equatable/equatable.dart';

class PropertyCategory extends Equatable {
  final String id;
  final String name;
  final String icon;
  final int propertyCount;
  final String? description;
  final String? color;
  final bool isActive;

  const PropertyCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.propertyCount,
    this.description,
    this.color,
    this.isActive = true,
  });

  factory PropertyCategory.fromJson(Map<String, dynamic> json) {
    return PropertyCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      propertyCount: (json['property_count'] as num).toInt(),
      description: json['description'] as String?,
      color: json['color'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    icon,
    propertyCount,
    description,
    color,
    isActive,
  ];

  PropertyCategory copyWith({
    String? id,
    String? name,
    String? icon,
    int? propertyCount,
    String? description,
    String? color,
    bool? isActive,
  }) {
    return PropertyCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      propertyCount: propertyCount ?? this.propertyCount,
      description: description ?? this.description,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
    );
  }
}
