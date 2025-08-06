import 'package:cached_network_image/cached_network_image.dart';
import 'package:diar_tunis/features/shared/domain/entities/destination.dart';
import 'package:diar_tunis/features/shared/widgets/custom_error_widget.dart';
import 'package:diar_tunis/features/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../properties/presentation/cubit/properties_cubit.dart';

class PopularDestinations extends StatelessWidget {
  const PopularDestinations({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertiesCubit, PropertiesState>(
      builder: (context, state) {
        if (state is PropertiesLoading) {
          return const SizedBox(height: 150, child: LoadingWidget());
        }

        if (state is PropertiesError) {
          return SizedBox(
            height: 150,
            child: CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<PropertiesCubit>().refreshData(),
            ),
          );
        }

        if (state is PropertiesLoaded) {
          final destinations = state.popularDestinations;

          if (destinations.isEmpty) {
            return const SizedBox(
              height: 150,
              child: Center(
                child: Text(
                  'No popular destinations available',
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
                  'Popular Destinations',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    final destination = destinations[index];
                    return _DestinationCard(
                      destination: destination,
                      onTap: () => _searchDestination(context, destination),
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

  void _searchDestination(BuildContext context, Destination destination) {
    // Navigate to search page with the destination city pre-filled
    Navigator.pushNamed(
      context,
      '/search',
      arguments: {
        'initialQuery': destination.name,
        'city': destination.name.split(',').first.trim(),
      },
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onTap;

  const _DestinationCard({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Background Image
                CachedNetworkImage(
                  imageUrl: destination.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.location_city,
                        size: 32,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),

                // Destination Info
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${destination.bookingCount} properties',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      if (destination.avgPrice > 0) ...[
                        const SizedBox(height: 2),
                        Text(
                          'From \$${destination.avgPrice.toStringAsFixed(0)}/night',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
