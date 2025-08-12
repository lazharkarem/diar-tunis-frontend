
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:diar_tunis/app/themes/colors.dart' as app_colors;
import 'package:diar_tunis/app/themes/text_styles.dart' as app_styles;
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/host/presentation/providers/host_property_provider.dart';
import 'package:diar_tunis/features/host/presentation/widgets/host_navigation_wrapper.dart';
import 'package:diar_tunis/features/host/presentation/widgets/host_stats_card.dart';
import 'package:diar_tunis/features/host/presentation/widgets/property_card.dart';

class HostDashboardPage extends StatefulWidget {
  const HostDashboardPage({super.key});

  @override
  State<HostDashboardPage> createState() => _HostDashboardPageState();
}

class _HostDashboardPageState extends State<HostDashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
    
    // Load properties when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HostPropertyProvider>().loadProperties();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HostNavigationWrapper(
      title: 'Dashboard',
      currentIndex: 0,
      floatingActionButton: _buildFloatingActionButton(),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                const SizedBox(height: 32),
                _buildStatsSection(),
                const SizedBox(height: 32),
                _buildQuickActionsSection(),
                const SizedBox(height: 32),
                _buildRecentBookingsSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final propertyProvider = context.watch<HostPropertyProvider>();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            app_colors.AppColors.primary,
            app_colors.AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: app_styles.AppTextStyles.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your properties are performing great',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildWelcomeStat(
                '${propertyProvider.totalProperties}', 
                'Properties',
              ),
              const SizedBox(width: 24),
              _buildWelcomeStat('4.8★', 'Rating'),
              const SizedBox(width: 24),
              _buildWelcomeStat('12', 'Bookings'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: app_styles.AppTextStyles.h4.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: app_styles.AppTextStyles.caption.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Performance Overview',
              style: app_styles.AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to detailed stats
              },
              child: Text(
                'View Details',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: const [
            HostStatsCard(
              title: 'Total Properties',
              value: '3',
              icon: Icons.home_outlined,
              color: AppColors.primary,
              trend: '+1',
              trendPositive: true,
            ),
            HostStatsCard(
              title: 'This Month',
              value: '12',
              icon: Icons.book_online_outlined,
              color: AppColors.success,
              subtitle: 'Bookings',
              trend: '+3',
              trendPositive: true,
            ),
            HostStatsCard(
              title: 'Total Earnings',
              value: '\$2,450',
              icon: Icons.attach_money_outlined,
              color: AppColors.secondary,
              subtitle: 'This month',
              trend: '+15%',
              trendPositive: true,
            ),
            HostStatsCard(
              title: 'Average Rating',
              value: '4.8',
              icon: Icons.star_outline,
              color: AppColors.warning,
              subtitle: 'Out of 5',
              trend: '+0.2',
              trendPositive: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: app_styles.AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            _buildQuickActionCard(
              context,
              'Add Property',
              Icons.add_home_outlined,
              AppColors.primary,
              () {
                // Navigate to add property
              },
            ),
            _buildQuickActionCard(
              context,
              'View Bookings',
              Icons.calendar_view_day_outlined,
              AppColors.success,
              () {
                // Navigate to bookings
              },
            ),
            _buildQuickActionCard(
              context,
              'Earnings Report',
              Icons.analytics_outlined,
              AppColors.secondary,
              () {
                // Navigate to earnings
              },
            ),
            _buildQuickActionCard(
              context,
              'Messages',
              Icons.message_outlined,
              app_colors.AppColors.info,
              () {
                // Navigate to messages
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: app_colors.AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: app_colors.AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPropertyDetails(Property property) {
    // TODO: Implement navigation to property details
    debugPrint('Navigate to property details: ${property.id}');
  }

  void _editProperty(Property property) {
    // TODO: Implement property editing
    debugPrint('Edit property: ${property.id}');
  }

  void _togglePropertyStatus(Property property) {
    // TODO: Implement status toggling
    debugPrint('Toggle status for property: ${property.id}');
  }

  void _viewPropertyBookings(Property property) {
    // TODO: Implement viewing bookings for property
    debugPrint('View bookings for property: ${property.id}');
  }

  Widget _buildRecentBookingsSection() {
    final propertyProvider = context.watch<HostPropertyProvider>();
    
    if (propertyProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (propertyProvider.error != null) {
      return Center(
        child: Text(
          propertyProvider.error!,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
        ),
      );
    }
    
    if (propertyProvider.properties.isEmpty) {
      return const Center(
        child: Text('No properties found'),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Properties',
          style: app_styles.AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: propertyProvider.properties.length,
          itemBuilder: (context, index) {
            final property = propertyProvider.properties[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: PropertyCard(
                property: property,
                onTap: () => _navigateToPropertyDetails(property),
                onEdit: () => _editProperty(property),
                onToggleStatus: () => _togglePropertyStatus(property),
                onViewBookings: () => _viewPropertyBookings(property),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, app_colors.AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          // Navigate to add property
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
