import 'package:cached_network_image/cached_network_image.dart';
import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:flutter/material.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
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

  // Helper method to build info row with icon
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // Get color based on property status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'inactive':
        return AppColors.error;
      case 'pending':
        return AppColors.warning;
      case 'available':
        return Colors.green;
      case 'booked':
        return Colors.orange;
      case 'maintenance':
        return Colors.blue;
      default:
        return AppColors.textSecondary;
    }
  }

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
                  // Property image with placeholder
                  property.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: property.images.first.imageUrl.startsWith('http')
                              ? property.images.first.imageUrl
                              : 'http://localhost:8000${property.images.first.imageUrl}',
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
                        )
                      : Container(
                          height: 200,
                          color: AppColors.surfaceVariant,
                          child: const Icon(
                            Icons.home,
                            size: 50,
                            color: AppColors.textSecondary,
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
                        color: _getStatusColor(property.status).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        property.status.toUpperCase(),
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

            // Property details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    property.title,
                    style: AppTextStyles.h5,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Location
                  if (property.address.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      Icons.location_on,
                      property.address,
                    ),
                  ],
                  
                  // Price and details
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${property.pricePerNight.toStringAsFixed(2)} / night',
                        style: AppTextStyles.h6.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildInfoRow(
                        Icons.hotel,
                        '${property.bedrooms} Beds • ${property.bathrooms} Baths',
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


}
