import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/features/host/presentation/widgets/property_card.dart';
import 'package:flutter/material.dart';

class MyPropertiesPage extends StatefulWidget {
  const MyPropertiesPage({super.key});

  @override
  State<MyPropertiesPage> createState() => _MyPropertiesPageState();
}

class _MyPropertiesPageState extends State<MyPropertiesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Properties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add property
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search your properties...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    // Implement search
                  },
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all'),
                      _buildFilterChip('Active', 'active'),
                      _buildFilterChip('Pending', 'pending'),
                      _buildFilterChip('Inactive', 'inactive'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Properties list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5, // Replace with actual data
              itemBuilder: (context, index) {
                return PropertyCard(
                  property: _getDummyProperty(index),
                  onTap: () {
                    _showPropertyDetails(context, index);
                  },
                  onEdit: () {
                    _editProperty(index);
                  },
                  onToggleStatus: () {
                    _togglePropertyStatus(index);
                  },
                  onViewBookings: () {
                    _viewPropertyBookings(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add property
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Property'),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primary,
      ),
    );
  }

  Map<String, dynamic> _getDummyProperty(int index) {
    final statuses = ['active', 'pending', 'inactive'];
    return {
      'id': 'property_$index',
      'title': 'Beautiful Property ${index + 1}',
      'location': 'Tunis, Tunisia',
      'price': '\$${(index + 1) * 50}',
      'status': statuses[index % 3],
      'images': ['https://example.com/image1.jpg'],
      'rating': 4.0 + (index % 10) / 10,
      'reviewCount': (index + 1) * 5,
      'bookingCount': (index + 1) * 3,
      'earnings': '\$${(index + 1) * 500}',
    };
  }

  void _showPropertyDetails(BuildContext context, int index) {
    // Navigate to property details
  }

  void _editProperty(int index) {
    // Navigate to edit property
  }

  void _togglePropertyStatus(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Property ${index + 1} status updated'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _viewPropertyBookings(int index) {
    // Navigate to property bookings
  }
}
