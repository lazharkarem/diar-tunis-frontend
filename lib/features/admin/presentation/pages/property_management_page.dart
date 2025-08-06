import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/features/admin/presentation/widgets/admin_navigation_wrapper.dart';
import 'package:diar_tunis/features/admin/presentation/widgets/property_list_item.dart';
import 'package:flutter/material.dart';

class PropertyManagementPage extends StatefulWidget {
  const PropertyManagementPage({super.key});

  @override
  State<PropertyManagementPage> createState() => _PropertyManagementPageState();
}

class _PropertyManagementPageState extends State<PropertyManagementPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminNavigationWrapper(
      title: 'Property Management',
      currentIndex: 2,
      child: Column(
        children: [
          // Tab bar
          Container(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
    );
  }

  Widget _buildPropertyList(String status) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 15, // Replace with actual data
      itemBuilder: (context, index) {
        return PropertyListItem(
          property: _getDummyProperty(index, status),
          onTap: () {
            _showPropertyDetails(context, index);
          },
          onApprove: status == 'pending'
              ? () {
                  _approveProperty(index);
                }
              : null,
          onReject: status == 'pending'
              ? () {
                  _rejectProperty(index);
                }
              : null,
          onEdit: () {
            _editProperty(index);
          },
          onDelete: () {
            _deleteProperty(index);
          },
        );
      },
    );
  }

  Map<String, dynamic> _getDummyProperty(int index, String status) {
    final statuses = ['pending', 'active', 'rejected'];
    return {
      'id': 'property_$index',
      'title': 'Beautiful Property ${index + 1}',
      'location': 'Tunis, Tunisia',
      'price': '\$${(index + 1) * 50}/night',
      'status': status == 'all' ? statuses[index % 3] : status,
      'hostName': 'Host ${index + 1}',
      'images': ['https://example.com/image1.jpg'],
      'rating': 4.0 + (index % 10) / 10,
      'reviewCount': (index + 1) * 5,
      'createdAt': DateTime.now().subtract(Duration(days: index * 2)),
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

  void _showPropertyDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Property ${index + 1} Details'),
        content: const Text('Property details would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _approveProperty(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Property ${index + 1} approved'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _rejectProperty(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Property ${index + 1} rejected'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _editProperty(int index) {
    // Navigate to edit property page
  }

  void _deleteProperty(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: Text('Are you sure you want to delete Property ${index + 1}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Property ${index + 1} deleted'),
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
