import 'package:cached_network_image/cached_network_image.dart';
import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingListItem extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onCancel;

  const BookingListItem({
    super.key,
    required this.booking,
    required this.onTap,
    this.onAccept,
    this.onReject,
    this.onCancel,
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
                          'Guest: ${booking['guestName']}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${DateFormat('MMM dd, yyyy').format(booking['checkInDate'])} - ${DateFormat('MMM dd, yyyy').format(booking['checkOutDate'])}',
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
                      if (onAccept != null)
                        TextButton(
                          onPressed: onAccept,
                          child: const Text('Accept'),
                        ),
                      if (onReject != null)
                        TextButton(
                          onPressed: onReject,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                          ),
                          child: const Text('Reject'),
                        ),
                      if (onCancel != null)
                        TextButton(
                          onPressed: onCancel,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.warning,
                          ),
                          child: const Text('Cancel'),
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
      case 'pending':
        return AppColors.warning;
      case 'confirmed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'completed':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }
}
