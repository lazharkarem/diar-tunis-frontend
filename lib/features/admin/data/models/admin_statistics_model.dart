import 'package:diar_tunis/features/admin/domain/entities/admin_statistics.dart';
import 'package:equatable/equatable.dart';

class AdminStatisticsModel extends Equatable {
  final int totalUsers;
  final int totalProperties;
  final int totalBookings;
  final double totalRevenue;
  final int activeUsers;
  final int pendingProperties;
  final Map<String, dynamic> monthlyStats;
  final List<Map<String, dynamic>> recentActivities;

  const AdminStatisticsModel({
    required this.totalUsers,
    required this.totalProperties,
    required this.totalBookings,
    required this.totalRevenue,
    required this.activeUsers,
    required this.pendingProperties,
    required this.monthlyStats,
    required this.recentActivities,
  });

  factory AdminStatisticsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatisticsModel(
      totalUsers: json['total_users'] ?? 0,
      totalProperties: json['total_properties'] ?? 0,
      totalBookings: json['total_bookings'] ?? 0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
      activeUsers: json['active_users'] ?? 0,
      pendingProperties: json['pending_properties'] ?? 0,
      monthlyStats: json['monthly_stats'] ?? {},
      recentActivities:
          (json['recent_activities'] as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_users': totalUsers,
      'total_properties': totalProperties,
      'total_bookings': totalBookings,
      'total_revenue': totalRevenue,
      'active_users': activeUsers,
      'pending_properties': pendingProperties,
      'monthly_stats': monthlyStats,
      'recent_activities': recentActivities,
    };
  }

  // Convert data model to domain entity
  AdminStatistics toDomain() {
    return AdminStatistics(
      totalUsers: totalUsers,
      totalProperties: totalProperties,
      totalBookings: totalBookings,
      totalRevenue: totalRevenue,
      activeUsers: activeUsers,
      pendingProperties: pendingProperties,
      monthlyStats: monthlyStats,
      recentActivities: recentActivities,
    );
  }

  @override
  List<Object?> get props => [
    totalUsers,
    totalProperties,
    totalBookings,
    totalRevenue,
    activeUsers,
    pendingProperties,
    monthlyStats,
    recentActivities,
  ];
}
