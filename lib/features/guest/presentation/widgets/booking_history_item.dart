import 'package:cached_network_image/cached_network_image.dart';
import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingHistoryItem extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onReview;

  const BookingHistoryItem({
    super.key,
    required this.booking,
    required this.onTap,
    this.onCancel,
    this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: booking['propertyImage'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.surfaceVariant,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking['propertyName'],
                          style: AppTextStyles.h6,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Check-in: ${DateFormat('MMM dd, yyyy').format(booking['checkInDate'])}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          'Check-out: ${DateFormat('MMM dd, yyyy').format(booking['checkOutDate'])}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: \$${booking['totalPrice'].toStringAsFixed(2)}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        booking['status'],
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking['status'].toString().toUpperCase(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: _getStatusColor(booking['status']),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (onCancel != null)
                        TextButton(
                          onPressed: onCancel,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.warning,
                          ),
                          child: const Text('Cancel Booking'),
                        ),
                      if (onReview != null)
                        ElevatedButton(
                          onPressed: onReview,
                          child: const Text('Leave Review'),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return AppColors.info;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}
