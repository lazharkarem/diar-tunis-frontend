import 'package:cached_network_image/cached_network_image.dart';
import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/core/widgets/error_widget.dart';
import 'package:diar_tunis/core/widgets/loading_widget.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:diar_tunis/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:diar_tunis/features/admin/presentation/widgets/admin_navigation_wrapper.dart';
import 'package:diar_tunis/features/admin/presentation/widgets/property_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diar_tunis/injection_container.dart' as di;

class PropertyManagementPage extends StatefulWidget {
  const PropertyManagementPage({super.key});

  @override
  State<PropertyManagementPage> createState() => _PropertyManagementPageState();
}

class _PropertyManagementPageState extends State<PropertyManagementPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  late AdminBloc _adminBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _adminBloc = di.sl<AdminBloc>();
    _adminBloc.add(GetAllPropertiesEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      bloc: _adminBloc,
      listener: (context, state) {
        if (state is PropertyStatusUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Property status updated successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          // Refresh the property list
          _adminBloc.add(GetAllPropertiesEvent());
        } else if (state is AdminError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: AdminNavigationWrapper(
        title: 'Property Management',
        currentIndex: 2,
        child: Column(
        children: [
          // Tab bar
          Container(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Pending'),
                Tab(text: 'Active'),
                Tab(text: 'Rejected'),
              ],
            ),
          ),
          // Search and filter bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search properties...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      // Implement search functionality
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                ),
              ],
            ),
          ),

          // Property list
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPropertyList('all'),
                _buildPropertyList('pending'),
                _buildPropertyList('active'),
                _buildPropertyList('rejected'),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildPropertyList(String status) {
    return BlocBuilder<AdminBloc, AdminState>(
      bloc: _adminBloc,
      builder: (context, state) {
        if (state is AdminLoading) {
          return const LoadingWidget();
        } else if (state is AdminError) {
          return ErrorMessageWidget(message: state.message);
        } else if (state is PropertiesLoaded) {
          final filteredProperties = status == 'all'
              ? state.properties
              : state.properties.where((property) => property.status == status).toList();
          
          if (filteredProperties.isEmpty) {
            return Center(
              child: Text(
                'No ${status == 'all' ? '' : status} properties found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredProperties.length,
            itemBuilder: (context, index) {
              final property = filteredProperties[index];
              return PropertyListItem(
                property: _mapPropertyToMap(property),
                onTap: () {
                  _showPropertyDetails(context, property);
                },
                onApprove: property.status == 'pending'
                    ? () {
                        _approveProperty(property.id);
                      }
                    : null,
                onReject: property.status == 'pending'
                    ? () {
                        _rejectProperty(property.id);
                      }
                    : null,
                onEdit: () {
                  _editProperty(property.id);
                },
                onDelete: () {
                  _deleteProperty(property.id);
                },
              );
            },
          );
        } else {
          return const Center(child: Text('No properties found'));
        }
      },
    );
  }
  
  Map<String, dynamic> _mapPropertyToMap(Property property) {
    return {
      'id': property.id,
      'title': property.title,
      'location': property.address.isNotEmpty ? property.address : '${property.city}, ${property.state}',
      'price': '\$${property.pricePerNight}/night',
      'status': property.status,
      'hostName': property.host?.name ?? 'Host ID: ${property.hostId ?? 'N/A'}',
      'images': property.images.isNotEmpty 
          ? [property.primaryImage?.imageUrl ?? 'https://via.placeholder.com/150'] 
          : ['https://via.placeholder.com/150'],
      'rating': 4.5, // This should come from property ratings
      'reviewCount': 10, // This should come from property reviews count
      'createdAt': property.createdAt,
    };
  }



  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Properties'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('High Rating (4.5+)'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Recently Added'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Has Reviews'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showPropertyDetails(BuildContext context, Property property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(property.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (property.images.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: property.primaryImage?.imageUrl ?? 'https://via.placeholder.com/150',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: AppColors.surfaceVariant,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text('Description', style: AppTextStyles.h6),
              Text(property.description.isNotEmpty ? property.description : 'No description provided'),
              const SizedBox(height: 8),
              Text('Location', style: AppTextStyles.h6),
              Text(property.address.isNotEmpty ? property.address : '${property.city}, ${property.state}'),
              const SizedBox(height: 8),
              Text('Price', style: AppTextStyles.h6),
              Text('\$${property.pricePerNight}/night'),
              const SizedBox(height: 8),
              Text('Details', style: AppTextStyles.h6),
              Text('Type: ${property.type}'),
              Text('Bedrooms: ${property.bedrooms}'),
              Text('Bathrooms: ${property.bathrooms}'),
              Text('Area: ${property.area} sq ft'),
              const SizedBox(height: 8),
              Text('Amenities', style: AppTextStyles.h6),
              Wrap(
                spacing: 8,
                children: property.amenities.map((amenity) => Chip(label: Text(amenity))).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _approveProperty(String propertyId) {
    _adminBloc.add(UpdatePropertyStatusEvent(
      propertyId: propertyId,
      status: 'active',
    ));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Property approval in progress...'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _rejectProperty(String propertyId) {
    _adminBloc.add(UpdatePropertyStatusEvent(
      propertyId: propertyId,
      status: 'rejected',
    ));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Property rejection in progress...'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _editProperty(String propertyId) {
    // Navigate to edit property page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit property functionality coming soon'),
      ),
    );
  }

  void _deleteProperty(String propertyId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: const Text('Are you sure you want to delete this property?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Here we would add the delete property event to the bloc
              // _adminBloc.add(DeletePropertyEvent(propertyId: propertyId));
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Delete property functionality coming soon'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
