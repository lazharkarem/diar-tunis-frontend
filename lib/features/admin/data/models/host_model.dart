import 'package:diar_tunis/features/admin/domain/entities/host.dart';
import 'package:json_annotation/json_annotation.dart';

part 'host_model.g.dart';

// Helper to safely parse string from dynamic value
String _toString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

@JsonSerializable()
class HostModel {
  @JsonKey(name: 'id', fromJson: _toString)
  final String id;
  
  @JsonKey(name: 'name')
  final String name;
  
  @JsonKey(name: 'email')
  final String email;
  
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;
  
  @JsonKey(name: 'is_active', defaultValue: true)
  final bool isActive;
  
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  
  const HostModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
    this.isActive = true,
    this.createdAt,
  });
  
  factory HostModel.fromJson(Map<String, dynamic> json) => 
      _$HostModelFromJson(json);
      
  Map<String, dynamic> toJson() => _$HostModelToJson(this);
  
  Host toEntity() {
    return Host(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
  
  factory HostModel.fromEntity(Host host) {
    return HostModel(
      id: host.id,
      name: host.name,
      email: host.email,
      phoneNumber: host.phoneNumber,
      profilePicture: host.profilePicture,
      isActive: host.isActive,
      createdAt: host.createdAt,
    );
  }
}
