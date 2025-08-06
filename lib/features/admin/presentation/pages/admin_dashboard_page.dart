import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/features/admin/presentation/widgets/admin_navigation_wrapper.dart';
import 'package:diar_tunis/features/admin/presentation/widgets/admin_stats_card.dart';
import 'package:diar_tunis/features/admin/presentation/widgets/recent_activities_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminNavigationWrapper(
      title: 'Admin Dashboard',
      currentIndex: 0,
      child: SingleChildScrollView(
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
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, Admin!',
                    style: AppTextStyles.h3.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Here\'s what\'s happening with Diar Tunis today',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats cards
            Text('Overview', style: AppTextStyles.h4),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: const [
                AdminStatsCard(
                  title: 'Total Users',
                  value: '1,234',
                  icon: Icons.people,
                  color: AppColors.primary,
                  trend: '+12%',
                ),
                AdminStatsCard(
                  title: 'Properties',
                  value: '456',
                  icon: Icons.home,
                  color: AppColors.secondary,
                  trend: '+8%',
                ),
                AdminStatsCard(
                  title: 'Bookings',
                  value: '789',
                  icon: Icons.book_online,
                  color: AppColors.success,
                  trend: '+15%',
                ),
                AdminStatsCard(
                  title: 'Revenue',
                  value: '\$12.5K',
                  icon: Icons.attach_money,
                  color: AppColors.accent,
                  trend: '+20%',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Quick actions
            Text('Quick Actions', style: AppTextStyles.h4),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildQuickActionCard(
                  context,
                  'Manage Users',
                  Icons.people_outline,
                  AppColors.primary,
                  () {
                    context.go('/admin_users');
                  },
                ),
                _buildQuickActionCard(
                  context,
                  'Properties',
                  Icons.home_outlined,
                  AppColors.secondary,
                  () {
                    context.go('/admin_properties');
                  },
                ),
                _buildQuickActionCard(
                  context,
                  'Bookings',
                  Icons.book_outlined,
                  AppColors.success,
                  () {
                    context.go('/admin_bookings');
                  },
                ),
                _buildQuickActionCard(
                  context,
                  'Reports',
                  Icons.analytics_outlined,
                  AppColors.info,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reports coming soon!')),
                    );
                  },
                ),
                _buildQuickActionCard(
                  context,
                  'Settings',
                  Icons.settings_outlined,
                  AppColors.textSecondary,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings coming soon!')),
                    );
                  },
                ),
                _buildQuickActionCard(
                  context,
                  'Support',
                  Icons.support_agent_outlined,
                  AppColors.warning,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Support coming soon!')),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Recent activities
            Text('Recent Activities', style: AppTextStyles.h4),
            const SizedBox(height: 16),

            const RecentActivitiesWidget(),
          ],
        ),
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
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  title,
                  style: AppTextStyles.labelSmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
