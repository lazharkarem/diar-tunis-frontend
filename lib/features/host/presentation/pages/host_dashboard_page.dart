import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/features/host/presentation/widgets/host_stats_card.dart';
import 'package:diar_tunis/features/host/presentation/widgets/recent_bookings_widget.dart';
import 'package:flutter/material.dart';

class HostDashboardPage extends StatelessWidget {
  const HostDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // Navigate to calendar
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondary, AppColors.secondaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, Host!',
                    style: AppTextStyles.h3.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your properties and bookings',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats cards
            Text('Your Performance', style: AppTextStyles.h4),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: const [
                HostStatsCard(
                  title: 'Properties',
                  value: '3',
                  icon: Icons.home,
                  color: AppColors.primary,
                ),
                HostStatsCard(
                  title: 'This Month',
                  value: '12',
                  icon: Icons.book_online,
                  color: AppColors.success,
                  subtitle: 'Bookings',
                ),
                HostStatsCard(
                  title: 'Earnings',
                  value: '\$2,450',
                  icon: Icons.attach_money,
                  color: AppColors.secondary,
                  subtitle: 'This month',
                ),
                HostStatsCard(
                  title: 'Rating',
                  value: '4.8',
                  icon: Icons.star,
                  color: AppColors.warning,
                  subtitle: 'Average',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Quick actions
            Text('Quick Actions', style: AppTextStyles.h4),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildQuickActionCard(
                  context,
                  'Add Property',
                  Icons.add_home,
                  AppColors.primary,
                  () {
                    // Navigate to add property
                  },
                ),
                _buildQuickActionCard(
                  context,
                  'View Bookings',
                  Icons.calendar_view_day,
                  AppColors.success,
                  () {
                    // Navigate to bookings
                  },
                ),
                _buildQuickActionCard(
                  context,
                  'Earnings Report',
                  Icons.analytics,
                  AppColors.secondary,
                  () {
                    // Navigate to earnings
                  },
                ),
                _buildQuickActionCard(
                  context,
                  'Messages',
                  Icons.message,
                  AppColors.info,
                  () {
                    // Navigate to messages
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Recent bookings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Bookings', style: AppTextStyles.h4),
                TextButton(
                  onPressed: () {
                    // Navigate to all bookings
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const RecentBookingsWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add property
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.labelMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
