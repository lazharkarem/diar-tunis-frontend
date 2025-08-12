import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/host/presentation/providers/host_property_provider.dart';
import 'package:diar_tunis/features/host/presentation/widgets/host_navigation_wrapper.dart';
import 'package:diar_tunis/features/host/presentation/widgets/property_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPropertiesPage extends StatefulWidget {
  const MyPropertiesPage({super.key});

  @override
  State<MyPropertiesPage> createState() => _MyPropertiesPageState();
}

class _MyPropertiesPageState extends State<MyPropertiesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HostPropertyProvider>();
      if (provider.properties.isEmpty) {
        provider.loadProperties();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HostPropertyProvider>(
      builder: (context, provider, child) {
        return HostNavigationWrapper(
          title: 'My Properties',
          currentIndex: 3,
          floatingActionButton: _buildFloatingActionButton(),
          child: Column(
            children: [
              _buildSearchSection(),
              _buildFilterSection(),
              if (provider.isLoading) 
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.error != null)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error loading properties',
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: provider.loadProperties,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (provider.properties.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No properties found'),
                  ),
                )
              else
                Expanded(
                  child: _buildPropertiesList(provider.properties),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search your properties...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textLight,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onChanged: (value) {
          // Implement search
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', 'all', Icons.list_alt_outlined),
            _buildFilterChip('Active', 'active', Icons.check_circle_outline),
            _buildFilterChip('Pending', 'pending', Icons.schedule_outlined),
            _buildFilterChip('Inactive', 'inactive', Icons.pause_circle_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isSelected = _selectedFilter == value;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedFilter = value;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertiesList(List<Property> properties) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<HostPropertyProvider>().loadProperties();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: PropertyCard(
              property: property,
              onTap: () {
                _showPropertyDetails(context, property);
              },
              onEdit: () {
                _editProperty(property);
              },
              onToggleStatus: () {
                _togglePropertyStatus(property);
              },
              onViewBookings: () {
                _viewPropertyBookings(property);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
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
      child: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add property
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Property',
          style: AppTextStyles.labelMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showPropertyDetails(BuildContext context, Property property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPropertyDetailsSheet(property),
    );
  }

  void _editProperty(Property property) {
    // TODO: Implement edit property navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit property: ${property.title}')),
    );
  }

  void _togglePropertyStatus(Property property) async {
    // TODO: Implement toggle property status
    final provider = context.read<HostPropertyProvider>();
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updating property status...')),
      );
      
      // TODO: Call API to update property status
      // await provider.togglePropertyStatus(property.id);
      
      // Refresh the list
      await provider.loadProperties();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property status updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating property: $e')),
      );
    }
  }

  void _viewPropertyBookings(Property property) {
    // TODO: Implement view bookings navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View bookings for: ${property.title}')),
    );
  }

  Widget _buildPropertyDetailsSheet(Property property) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: Text(
              property.title,
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // TODO: Add property details
        ],
      ),
    );
  }
}
