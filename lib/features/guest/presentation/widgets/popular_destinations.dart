import 'package:cached_network_image/cached_network_image.dart';
import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class PopularDestinations extends StatelessWidget {
  const PopularDestinations({super.key});

  final List<Map<String, dynamic>> _destinations = const [
    {
      'name': 'Sidi Bou Said',
      'image': 'https://example.com/sidi_bou_said.jpg',
      'properties': '120 properties',
    },
    {
      'name': 'Hammamet',
      'image': 'https://example.com/hammamet.jpg',
      'properties': '90 properties',
    },
    {
      'name': 'Djerba',
      'image': 'https://example.com/djerba.jpg',
      'properties': '70 properties',
    },
    {
      'name': 'Tozeur',
      'image': 'https://example.com/tozeur.jpg',
      'properties': '40 properties',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _destinations.length,
        itemBuilder: (context, index) {
          final destination = _destinations[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                // Navigate to destination properties
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: destination['image'],
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 120,
                        height: 120,
                        color: AppColors.surfaceVariant,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 120,
                        height: 120,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    destination['name'],
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    destination['properties'],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
