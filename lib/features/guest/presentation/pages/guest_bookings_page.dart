import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/features/guest/presentation/widgets/guest_navigation_wrapper.dart';
import 'package:diar_tunis/features/guest/presentation/widgets/booking_history_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GuestBookingsPage extends StatefulWidget {
  const GuestBookingsPage({super.key});

  @override
  State<GuestBookingsPage> createState() => _GuestBookingsPageState();
}

class _GuestBookingsPageState extends State<GuestBookingsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _bookings = [
    {
      'id': '1',
      'propertyName': 'Luxury Beach Villa',
      'propertyImage': 'https://example.com/villa1.jpg',
      'checkInDate': DateTime.now().add(const Duration(days: 15)),
      'checkOutDate': DateTime.now().add(const Duration(days: 20)),
      'totalPrice': 1250.0,
      'status': 'upcoming',
    },
    {
      'id': '2',
      'propertyName': 'Modern City Apartment',
      'propertyImage': 'https://example.com/apartment1.jpg',
      'checkInDate': DateTime.now().add(const Duration(days: 30)),
      'checkOutDate': DateTime.now().add(const Duration(days: 35)),
      'totalPrice': 600.0,
      'status': 'upcoming',
    },
    {
      'id': '3',
      'propertyName': 'Historic Riad',
      'propertyImage': 'https://example.com/riad1.jpg',
      'checkInDate': DateTime.now().subtract(const Duration(days: 10)),
      'checkOutDate': DateTime.now().subtract(const Duration(days: 5)),
      'totalPrice': 900.0,
      'status': 'completed',
    },
    {
      'id': '4',
      'propertyName': 'Desert Oasis Villa',
      'propertyImage': 'https://example.com/villa2.jpg',
      'checkInDate': DateTime.now().subtract(const Duration(days: 30)),
      'checkOutDate': DateTime.now().subtract(const Duration(days: 25)),
      'totalPrice': 1500.0,
      'status': 'completed',
    },
    {
      'id': '5',
      'propertyName': 'Seaside Cottage',
      'propertyImage': 'https://example.com/cottage1.jpg',
      'checkInDate': DateTime.now().subtract(const Duration(days: 60)),
      'checkOutDate': DateTime.now().subtract(const Duration(days: 55)),
      'totalPrice': 750.0,
      'status': 'cancelled',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GuestNavigationWrapper(
      title: 'My Bookings',
      currentIndex: 3,
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBookingsList('upcoming'),
                      _buildBookingsList('completed'),
                      _buildBookingsList('cancelled'),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.calendar_today,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Bookings',
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage your property reservations',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelMedium,
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Completed'),
          Tab(text: 'Cancelled'),
        ],
      ),
    );
  }

  Widget _buildBookingsList(String status) {
    final filteredBookings = _bookings.where((booking) => booking['status'] == status).toList();
    
    if (filteredBookings.isEmpty) {
      return _buildEmptyState(status);
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        return BookingHistoryItem(
          booking: booking,
          onTap: () => _showBookingDetails(context, booking),
          onCancel: status == 'upcoming'
              ? () => _cancelBooking(context, booking)
              : null,
          onReview: status == 'completed'
              ? () => _leaveReview(context, booking)
              : null,
        );
      },
    );
  }

  Widget _buildEmptyState(String status) {
    IconData icon;
    String title;
    String message;
    
    switch (status) {
      case 'upcoming':
        icon = Icons.calendar_today;
        title = 'No Upcoming Bookings';
        message = 'You don\'t have any upcoming reservations';
        break;
      case 'completed':
        icon = Icons.check_circle_outline;
        title = 'No Completed Bookings';
        message = 'You haven\'t completed any bookings yet';
        break;
      case 'cancelled':
        icon = Icons.cancel_outlined;
        title = 'No Cancelled Bookings';
        message = 'You don\'t have any cancelled bookings';
        break;
      default:
        icon = Icons.calendar_today;
        title = 'No Bookings';
        message = 'You don\'t have any bookings';
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Navigate to search or home
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Explore Properties',
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Property: ${booking['propertyName']}'),
            const SizedBox(height: 8),
            Text('Check-in: ${DateFormat('MMM dd, yyyy').format(booking['checkInDate'])}'),
            Text('Check-out: ${DateFormat('MMM dd, yyyy').format(booking['checkOutDate'])}'),
            const SizedBox(height: 8),
            Text('Total: \$${booking['totalPrice'].toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Status: ${booking['status'].toString().toUpperCase()}'),
          ],
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

  void _cancelBooking(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text('Are you sure you want to cancel your booking at ${booking['propertyName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                final index = _bookings.indexWhere((b) => b['id'] == booking['id']);
                if (index != -1) {
                  _bookings[index]['status'] = 'cancelled';
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking cancelled successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _leaveReview(BuildContext context, Map<String, dynamic> booking) {
    final TextEditingController reviewController = TextEditingController();
    double rating = 5.0;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Review ${booking['propertyName']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Rating
              Text('Rating', style: AppTextStyles.labelMedium),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        rating = index + 1.0;
                      });
                    },
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: AppColors.warning,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Review text
              TextField(
                controller: reviewController,
                decoration: InputDecoration(
                  labelText: 'Your Review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
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
                    content: Text('Review submitted successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}