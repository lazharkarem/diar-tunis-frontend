import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Import the correct property model/entity
import 'package:diar_tunis/features/admin/domain/entities/property.dart';

// Define theme colors if not available
class AppColors {
  static const Color primary = Colors.blue;
  static const Color secondary = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
  static const Color success = Colors.green;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color shadow = Color(0x1A000000);
}

// Define text styles if not available
class AppTextStyles {
  static const TextStyle bodySmall = TextStyle(fontSize: 12, color: AppColors.textSecondary);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14, color: AppColors.textPrimary);
  static const TextStyle bodyLarge = TextStyle(fontSize: 16, color: AppColors.textPrimary);
  static const TextStyle labelSmall = TextStyle(fontSize: 11, fontWeight: FontWeight.w500);
  static const TextStyle labelMedium = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
  static const TextStyle labelLarge = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static const TextStyle h5 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const TextStyle h6 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const TextStyle caption = TextStyle(fontSize: 10, color: AppColors.textSecondary);
}

class PropertyImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const PropertyImageWidget({
    super.key,
    this.imageUrl,
    this.width = double.infinity,
    this.height = 200,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    return Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Error loading image: $error');
        debugPrint('URL: $imageUrl');
        return _buildPlaceholder();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoading();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(Icons.home, color: Colors.grey, size: 40),
    );
  }

  Widget _buildLoading() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

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
              child: PropertyImageWidget(
                imageUrl: property.images.isNotEmpty ? _getImageUrl(property.images.first) : null,
                height: 180,
                width: double.infinity,
              ),
            ),
            
            // Property details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: AppTextStyles.h6,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(property.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          property.status.toUpperCase(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: _getStatusColor(property.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Price
                  Text(
                    '\$${property.pricePerNight.toStringAsFixed(2)} / night',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${property.city}, ${property.state}',
                          style: AppTextStyles.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onViewBookings,
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: const Text('Bookings'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
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
  
  String _getImageUrl(PropertyImage image) {
    String url = image.imageUrl;

    if (url.isEmpty) {
      debugPrint('Warning: Received an empty image URL.');
      return ''; // Return empty string for placeholder
    }

    // Check if it's already a full URL
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    // Handle Laravel storage paths
    if (url.startsWith('property-images/')) {
      return 'http://10.0.2.2:8000/storage/$url';
    }

    // Handle relative paths starting with a slash
    if (url.startsWith('/')) {
      return 'http://10.0.2.2:8000$url';
    }

    debugPrint('Unrecognized image URL format: $url');
    // Fallback for any other case, though it might not be correct
    return 'http://10.0.2.2:8000/$url';
  }

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
}
