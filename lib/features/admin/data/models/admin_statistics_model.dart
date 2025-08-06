import 'package:equatable/equatable.dart';

class AdminStatisticsModel extends Equatable {
  final int totalUsers;
  final int totalProperties;
  final int totalBookings;
  final int totalServiceProviders;
  final int totalAppointments;
  final double totalRevenue;
  final int pendingBookings;
  final int pendingProperties;
  final int pendingProviders;

  const AdminStatisticsModel({
    required this.totalUsers,
    required this.totalProperties,
    required this.totalBookings,
    required this.totalServiceProviders,
    required this.totalAppointments,
    required this.totalRevenue,
    required this.pendingBookings,
    required this.pendingProperties,
    required this.pendingProviders,
  });

  factory AdminStatisticsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatisticsModel(
      totalUsers: json['total_users'] ?? 0,
      totalProperties: json['total_properties'] ?? 0,
      totalBookings: json['total_bookings'] ?? 0,
      totalServiceProviders: json['total_service_providers'] ?? 0,
      totalAppointments: json['total_appointments'] ?? 0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
      pendingBookings: json['pending_bookings'] ?? 0,
      pendingProperties: json['pending_properties'] ?? 0,
      pendingProviders: json['pending_providers'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_users': totalUsers,
      'total_properties': totalProperties,
      'total_bookings': totalBookings,
      'total_service_providers': totalServiceProviders,
      'total_appointments': totalAppointments,
      'total_revenue': totalRevenue,
      'pending_bookings': pendingBookings,
      'pending_properties': pendingProperties,
      'pending_providers': pendingProviders,
    };
  }

  @override
  List<Object?> get props => [
    totalUsers,
    totalProperties,
    totalBookings,
    totalServiceProviders,
    totalAppointments,
    totalRevenue,
    pendingBookings,
    pendingProperties,
    pendingProviders,
  ];
}
