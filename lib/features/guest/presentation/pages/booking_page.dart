import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTimeRange? _selectedDateRange;
  int _guestCount = 1;
  bool _agreeToTerms = false;

  // Dummy property data
  final Map<String, dynamic> _property = const {
    'title': 'Luxurious Villa with Sea View',
    'price': 250.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Property')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking for: ${_property['title']}', style: AppTextStyles.h4),
            const SizedBox(height: 24),

            // Select Dates
            Text('Select Dates', style: AppTextStyles.h5),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDateRange,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDateRange == null
                          ? 'Choose check-in and check-out dates'
                          : '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Number of Guests
            Text('Number of Guests', style: AppTextStyles.h5),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 12),
                      Text(
                        '$_guestCount guest${_guestCount > 1 ? 's' : ''}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _guestCount > 1
                            ? () => setState(() => _guestCount--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _guestCount++),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Price Details
            Text('Price Details', style: AppTextStyles.h5),
            const SizedBox(height: 8),
            _buildPriceRow(
              'Nightly Rate',
              '\$${_property['price'].toStringAsFixed(2)}',
            ),
            _buildPriceRow('Number of Nights', '${_calculateNights()}'),
            _buildPriceRow('Service Fee', '\$25.00'),
            Divider(color: AppColors.divider),
            _buildPriceRow(
              'Total',
              '\$${_calculateTotal().toStringAsFixed(2)}',
              isTotal: true,
            ),

            const SizedBox(height: 24),

            // Terms and Conditions
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'I agree to the terms and conditions',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _agreeToTerms && _selectedDateRange != null
                    ? _confirmBooking
                    : null,
                child: const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)
                : AppTextStyles.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  )
                : AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int _calculateNights() {
    if (_selectedDateRange == null) return 0;
    return _selectedDateRange!.duration.inDays;
  }

  double _calculateTotal() {
    final nights = _calculateNights();
    final nightlyRate = _property['price'];
    return (nights * nightlyRate) + 25.0; // Add dummy service fee
  }

  void _confirmBooking() {
    // Implement booking confirmation logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking confirmed for ${_property['title']}!'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context); // Go back to property details or home
  }
}
