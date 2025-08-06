import 'package:cached_network_image/cached_network_image.dart';
import 'package:diar_tunis/features/admin/domain/entities/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../properties/presentation/cubit/properties_cubit.dart';

class FeaturedProperties extends StatefulWidget {
  const FeaturedProperties({super.key});

  @override
  State<FeaturedProperties> createState() => _FeaturedPropertiesState();
}

class _FeaturedPropertiesState extends State<FeaturedProperties> {
  @override
  void initState() {
    super.initState();
    // Load featured properties when widget initializes
    context.read<PropertiesCubit>().loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertiesCubit, PropertiesState>(
      builder: (context, state) {
        if (state is PropertiesLoading) {
          return const SizedBox(height: 200, child: LoadingWidget());
        }

        if (state is PropertiesError) {
          return SizedBox(
            height: 200,
            child: CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<PropertiesCubit>().loadInitialData(),
            ),
          );
        }

        if (state is PropertiesLoaded) {
          final featuredProperties = state.featuredProperties;

          if (featuredProperties.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'No featured properties available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Featured Properties',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: featuredProperties.length,
                  itemBuilder: (context, index) {
                    final property = featuredProperties[index];
                    return _PropertyCard(
                      property: property,
                      onTap: () => _navigateToPropertyDetail(context, property),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _navigateToPropertyDetail(BuildContext context, Property property) {
    Navigator.pushNamed(
      context,
      '/property-detail',
      arguments: {'propertyId': property.id},
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;

  const _PropertyCard({required this.property, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Image
              SizedBox(
                height: 160,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: property.primaryImage?.imageUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.home, size: 48, color: Colors.grey),
                    ),
                  ),
                ),
              ),

              // Property Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        property.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${property.city}, ${property.state}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Price and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${property.pricePerNight.toStringAsFixed(0)}/night',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, size: 14, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(
                                '4.5', // You might want to calculate this from reviews
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
