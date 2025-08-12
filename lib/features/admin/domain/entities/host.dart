import 'package:equatable/equatable.dart';

class Host extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;
  final bool isActive;
  final DateTime? createdAt;

  const Host({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
    this.isActive = true,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        profilePicture,
        isActive,
        createdAt,
      ];
}
