import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String id;
  final String userId;
  final String propertyId;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfGuests;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.startDate,
    required this.endDate,
    required this.numberOfGuests,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    propertyId,
    startDate,
    endDate,
    numberOfGuests,
    totalPrice,
    status,
    createdAt,
  ];
}
