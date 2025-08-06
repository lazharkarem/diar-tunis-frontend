import 'package:cached_network_image/cached_network_image.dart';
import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;
  final VoidCallback onViewBookings;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onViewBookings,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: property['images'][0],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: AppColors.surfaceVariant,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: AppColors.surfaceVariant,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  // Status badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          property['status'],
                        ).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        property['status'].toString().toUpperCase(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['title'],
                    style: AppTextStyles.h5,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property['location'],
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${property['price']} / night',
                        style: AppTextStyles.h6.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.warning,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${property['rating']} (${property['reviewCount']} reviews)',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: onViewBookings,
                        child: const Text('View Bookings'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: onEdit,
                        child: const Text('Edit Property'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'inactive':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}
