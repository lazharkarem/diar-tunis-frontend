import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/features/host/presentation/widgets/booking_list_item.dart';
import 'package:flutter/material.dart';

class BookingsListPage extends StatefulWidget {
  const BookingsListPage({super.key});

  @override
  State<BookingsListPage> createState() => _BookingsListPageState();
}

class _BookingsListPageState extends State<BookingsListPage>
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search bookings...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
          ),

          // Booking list
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingList('all'),
                _buildBookingList('pending'),
                _buildBookingList('confirmed'),
                _buildBookingList('completed'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(String status) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 10, // Replace with actual data
      itemBuilder: (context, index) {
        return BookingListItem(
          booking: _getDummyBooking(index, status),
          onTap: () {
            _showBookingDetails(context, index);
          },
          onAccept: status == 'pending'
              ? () {
                  _acceptBooking(index);
                }
              : null,
          onReject: status == 'pending'
              ? () {
                  _rejectBooking(index);
                }
              : null,
          onCancel: status == 'confirmed'
              ? () {
                  _cancelBooking(index);
                }
              : null,
        );
      },
    );
  }

  Map<String, dynamic> _getDummyBooking(int index, String status) {
    final statuses = ['pending', 'confirmed', 'completed'];
    return {
      'id': 'booking_$index',
      'propertyName': 'Property ${index + 1}',
      'guestName': 'Guest ${index + 1}',
      'checkInDate': DateTime.now().add(Duration(days: index * 2)),
      'checkOutDate': DateTime.now().add(Duration(days: index * 2 + 5)),
      'totalPrice': (index + 1) * 100.0,
      'status': status == 'all' ? statuses[index % 3] : status,
      'propertyImage': 'https://example.com/property_image.jpg',
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

  void _acceptBooking(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking ${index + 1} accepted'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _rejectBooking(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking ${index + 1} rejected'),
        backgroundColor: AppColors.error,
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
}
