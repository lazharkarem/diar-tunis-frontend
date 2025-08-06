import 'package:equatable/equatable.dart';

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
