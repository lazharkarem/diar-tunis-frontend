import 'package:diar_tunis/features/guest/presentation/widgets/property_card.dart';
import 'package:flutter/material.dart';

class FeaturedProperties extends StatelessWidget {
  const FeaturedProperties({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5, // Replace with actual data
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: 250, // Adjust width as needed
              child: PropertyCard(
                property: _getDummyProperty(index),
                onTap: () {
                  // Navigate to property details
                },
                onFavorite: () {
                  // Handle favorite toggle
                },
                isFavorite: index % 2 == 0, // Dummy favorite status
              ),
            ),
          );
        },
      ),
    );
  }

  Map<String, dynamic> _getDummyProperty(int index) {
    return {
      'id': 'featured_property_$index',
      'title': 'Featured Villa ${index + 1}',
      'location': 'Hammamet, Tunisia',
      'price': '\$${(index + 1) * 75}',
      'images': ['https://example.com/villa_featured_${index + 1}.jpg'],
      'rating': 4.5,
      'reviewCount': 25,
    };
  }
}
