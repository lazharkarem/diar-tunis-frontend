import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showSearchDialog(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Where to?',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Anywhere • Any week • Add guests',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.tune, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SearchBottomSheet(),
    );
  }
}

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final TextEditingController _locationController = TextEditingController();
  DateTimeRange? _selectedDateRange;
  int _guestCount = 1;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Search', style: AppTextStyles.h4),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  Text('Where', style: AppTextStyles.h6),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      hintText: 'Search destinations',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dates
                  Text('When', style: AppTextStyles.h6),
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
                                ? 'Select dates'
                                : '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Guests
                  Text('Who', style: AppTextStyles.h6),
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
                ],
              ),
            ),
          ),

          // Search button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _performSearch,
                child: const Text('Search'),
              ),
            ),
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

  void _performSearch() {
    // Implement search logic
    Navigator.pop(context);
    // Navigate to search results
  }
}
