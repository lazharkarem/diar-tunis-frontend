import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class BookingManagementPage extends StatelessWidget {
  const BookingManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', true),
                  _buildFilterChip('Pending', false),
                  _buildFilterChip('Confirmed', false),
                  _buildFilterChip('Cancelled', false),
                  _buildFilterChip('Completed', false),
                ],
              ),
            ),
          ),
          
          // Bookings list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10, // Mock data
              itemBuilder: (context, index) {
                return _buildBookingCard(context, index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new booking (if needed)
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // Handle filter selection
        },
        selectedColor: AppColors.primaryLight,
        checkmarkColor: AppColors.primary,
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, int index) {
    final statuses = ['pending', 'confirmed', 'cancelled', 'completed'];
    final status = statuses[index % statuses.length];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${1000 + index}',
                  style: AppTextStyles.h6,
                ),
                _buildStatusChip(status),
              ],
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'John Doe',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.home, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Luxury Villa in Sidi Bou Said',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Dec 15-20, 2024',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const Spacer(),
                Text(
                  'TND 450.00',
                  style: AppTextStyles.h6.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status == 'pending') ...[
                  TextButton(
                    onPressed: () {
                      _showRejectDialog(context);
                    },
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _confirmBooking(context);
                    },
                    child: const Text('Confirm'),
                  ),
                ] else ...[
                  TextButton(
                    onPressed: () {
                      _viewBookingDetails(context);
                    },
                    child: const Text('View Details'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'pending':
        color = AppColors.warning;
        break;
      case 'confirmed':
        color = AppColors.info;
        break;
      case 'completed':
        color = AppColors.success;
        break;
      case 'cancelled':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _confirmBooking(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking confirmed successfully')),
    );
  }

  void _showRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Booking'),
        content: const Text('Are you sure you want to reject this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking rejected')),
              );
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _viewBookingDetails(BuildContext context) {
    // Navigate to booking details page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View booking details')),
    );
  }
}
