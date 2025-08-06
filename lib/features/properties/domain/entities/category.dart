import 'package:diar_tunis/features/shared/domain/entities/property_category.dart';
import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String icon;
  final int propertyCount;
  final String? description;
  final String? color;
  final bool isActive;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.propertyCount,
    this.description,
    this.color,
    this.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      propertyCount: json['property_count'] ?? 0,
      description: json['description'],
      color: json['color'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'property_count': propertyCount,
      'description': description,
      'color': color,
      'is_active': isActive,
    };
  }

  PropertyCategory toDomain() {
    return PropertyCategory(
      id: id,
      name: name,
      icon: icon,
      propertyCount: propertyCount,
      description: description,
      color: color,
      isActive: isActive,
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
}
