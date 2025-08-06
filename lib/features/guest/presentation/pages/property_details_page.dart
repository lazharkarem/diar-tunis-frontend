import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class PropertyDetailsPage extends StatefulWidget {
  final String propertyId;

  const PropertyDetailsPage({super.key, required this.propertyId});

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  int _currentImageIndex = 0;

  // Dummy data for property details
  final Map<String, dynamic> _property = const {
    'id': '1',
    'title': 'Luxurious Villa with Sea View',
    'location': 'Sidi Bou Said, Tunis',
    'price': '\$250',
    'description':
        'Experience the ultimate luxury in this stunning villa overlooking the Mediterranean Sea. Perfect for a relaxing getaway, this villa offers spacious rooms, a private pool, and breathtaking views. Located in the picturesque village of Sidi Bou Said, you ll be close to local attractions, cafes, and art galleries.',
    'images': [
      'https://example.com/villa_detail_1.jpg',
      'https://example.com/villa_detail_2.jpg',
      'https://example.com/villa_detail_3.jpg',
      'https://example.com/villa_detail_4.jpg',
    ],
    'amenities': [
      {'name': 'Swimming Pool', 'icon': Icons.pool},
      {'name': 'Wi-Fi', 'icon': Icons.wifi},
      {'name': 'Air Conditioning', 'icon': Icons.ac_unit},
      {'name': 'Kitchen', 'icon': Icons.kitchen},
      {'name': 'Parking', 'icon': Icons.local_parking},
      {'name': 'TV', 'icon': Icons.tv},
    ],
    'rating': 4.8,
    'reviewCount': 120,
    'hostName': 'Ahmed Ben Salah',
    'hostAvatar': 'https://example.com/host_avatar.jpg',
    'reviews': [
      {
        'reviewerName': 'John Doe',
        'rating': 5.0,
        'comment':
            'Absolutely stunning villa! Had an amazing time. The views are incredible.',
        'date': '2024-01-15',
      },
      {
        'reviewerName': 'Jane Smith',
        'rating': 4.5,
        'comment':
            'Beautiful place, great location. A bit pricey but worth it.',
        'date': '2024-02-20',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  CarouselSlider.builder(
                    itemCount: _property['images'].length,
                    itemBuilder: (context, index, realIndex) {
                      return CachedNetworkImage(
                        imageUrl: _property['images'][index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: AppColors.surfaceVariant,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      aspectRatio: 16 / 9,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _property['images'].asMap().entries.map((
                        entry,
                      ) {
                        return GestureDetector(
                          onTap: () => {},
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(
                                alpha: _currentImageIndex == entry.key ? 0.9 : 0.4,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_property['title'], style: AppTextStyles.h2),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _property['location'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.star,
                        size: 20,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_property['rating']} (${_property['reviewCount']} reviews)',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${_property['price']} / night',
                    style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: AppColors.divider),
                  const SizedBox(height: 16),
                  Text('Description', style: AppTextStyles.h4),
                  const SizedBox(height: 8),
                  Text(
                    _property['description'],
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Divider(color: AppColors.divider),
                  const SizedBox(height: 16),
                  Text('Amenities', style: AppTextStyles.h4),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: _property['amenities'].length,
                    itemBuilder: (context, index) {
                      final amenity = _property['amenities'][index];
                      return Column(
                        children: [
                          Icon(
                            amenity['icon'],
                            size: 30,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            amenity['name'],
                            style: AppTextStyles.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Divider(color: AppColors.divider),
                  const SizedBox(height: 16),
                  Text('About the Host', style: AppTextStyles.h4),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(
                          _property['hostAvatar'],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_property['hostName'], style: AppTextStyles.h5),
                          Text(
                            'Host since 2022',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(color: AppColors.divider),
                  const SizedBox(height: 16),
                  Text('Reviews', style: AppTextStyles.h4),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _property['reviews'].length,
                    itemBuilder: (context, index) {
                      final review = _property['reviews'][index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    review['reviewerName'],
                                    style: AppTextStyles.h6,
                                  ),
                                  Row(
                                    children: List.generate(
                                      review['rating'].toInt(),
                                      (i) => const Icon(
                                        Icons.star,
                                        color: AppColors.warning,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                review['comment'],
                                style: AppTextStyles.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                review['date'],
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price per night',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '\$${_property['price']}',
                  style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to booking page
              },
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
