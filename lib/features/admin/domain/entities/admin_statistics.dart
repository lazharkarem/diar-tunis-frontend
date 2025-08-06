import 'package:equatable/equatable.dart';

class AdminStatistics extends Equatable {
  final int totalUsers;
  final int totalProperties;
  final int totalBookings;
  final double totalRevenue;
  final int activeUsers;
  final int pendingProperties;
  final Map<String, dynamic> monthlyStats;
  final List<Map<String, dynamic>> recentActivities;

  const AdminStatistics({
    required this.totalUsers,
    required this.totalProperties,
    required this.totalBookings,
    required this.totalRevenue,
    required this.activeUsers,
    required this.pendingProperties,
    required this.monthlyStats,
    required this.recentActivities,
  });

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
