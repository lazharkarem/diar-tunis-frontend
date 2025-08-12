import 'package:diar_tunis/features/admin/domain/entities/booking.dart';
import 'package:diar_tunis/features/shared/data/models/property_model.dart';
import 'package:diar_tunis/features/shared/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

class BookingModel extends Equatable {
  final int id;
  final int userId;
  final int propertyId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalAmount;
  final String status;
  final UserModel? user;
  final PropertyModel? property;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalAmount,
    required this.status,
    this.user,
    this.property,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: _intFromJson(json['id']),
      userId: _intFromJson(json['user_id']),
      propertyId: _intFromJson(json['property_id']),
      checkIn: DateTime.parse(json['check_in']),
      checkOut: DateTime.parse(json['check_out']),
      guests: json['guests'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      property: json['property'] != null
          ? PropertyModel.fromJson(json['property'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'property_id': propertyId,
      'check_in': checkIn.toIso8601String(),
      'check_out': checkOut.toIso8601String(),
      'guests': guests,
      'total_amount': totalAmount,
      'status': status,
      'user': user?.toJson(),
      'property': property?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Convert data model to domain entity
  Booking toDomain() {
    return Booking(
      id: id.toString(),
      userId: userId.toString(),
      propertyId: propertyId.toString(),
      startDate: checkIn,
      endDate: checkOut,
      numberOfGuests: guests,
      totalPrice: totalAmount,
      status: status,
      createdAt: createdAt,
    );
  }

  static int _intFromJson(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  int get nights => checkOut.difference(checkIn).inDays;

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';

  @override
  List<Object?> get props => [
    id,
    userId,
    propertyId,
    checkIn,
    checkOut,
    guests,
    totalAmount,
    status,
    user,
    property,
    createdAt,
    updatedAt,
  ];
}
