import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/features/guest/presentation/widgets/booking_history_item.dart';
import 'package:diar_tunis/features/guest/presentation/widgets/guest_navigation_wrapper.dart';
import 'package:flutter/material.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

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
          Container(
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
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList('upcoming'),
                _buildBookingList('completed'),
                _buildBookingList('cancelled'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(String status) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Replace with actual data
      itemBuilder: (context, index) {
        return BookingHistoryItem(
          booking: _getDummyBooking(index, status),
          onTap: () {
            _showBookingDetails(context, index);
          },
          onCancel: status == 'upcoming'
              ? () {
                  _cancelBooking(index);
                }
              : null,
          onReview: status == 'completed'
              ? () {
                  _leaveReview(index);
                }
              : null,
        );
      },
    );
  }

  Map<String, dynamic> _getDummyBooking(int index, String status) {
    final statuses = ['upcoming', 'completed', 'cancelled'];
    return {
      'id': 'booking_history_$index',
      'propertyName': 'Property ${index + 1}',
      'propertyImage': 'https://example.com/property_image.jpg',
      'checkInDate': DateTime.now().add(Duration(days: index * 7)),
      'checkOutDate': DateTime.now().add(Duration(days: index * 7 + 3)),
      'totalPrice': (index + 1) * 150.0,
      'status': status == 'all' ? statuses[index % 3] : status,
    };
  }

  void _showBookingDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking ${index + 1} Details'),
        content: const Text('Booking details would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _cancelBooking(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text('Are you sure you want to cancel booking ${index + 1}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking ${index + 1} cancelled'),
                  backgroundColor: AppColors.error,
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

  void _leaveReview(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Leave Review for Property ${index + 1}'),
        content: const Text('Review form would go here'),
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
                  content: Text('Review submitted for Property ${index + 1}!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}
