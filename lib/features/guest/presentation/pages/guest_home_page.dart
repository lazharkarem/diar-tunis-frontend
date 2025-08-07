import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:diar_tunis/features/guest/presentation/widgets/category_chips.dart';
import 'package:diar_tunis/features/guest/presentation/widgets/featured_properties.dart';
import 'package:diar_tunis/features/guest/presentation/widgets/popular_destinations.dart';
import 'package:diar_tunis/features/guest/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';

class GuestHomePage extends StatefulWidget {
  const GuestHomePage({super.key});

  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

class _GuestHomePageState extends State<GuestHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App bar with search
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Discover Tunisia',
                          style: AppTextStyles.h2.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Find unique places to stay',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SearchBarWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Categories
                const CategoryChips(),

                const SizedBox(height: 32),

                // Featured properties
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Featured Properties', style: AppTextStyles.h4),
                      TextButton(
                        onPressed: () {
                          // Navigate to all properties
                        },
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                const FeaturedProperties(),

                const SizedBox(height: 32),

                // Popular destinations
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Popular Destinations', style: AppTextStyles.h4),
                ),

                const SizedBox(height: 16),

                const PopularDestinations(),

                const SizedBox(height: 32),

                // Cultural experiences section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.secondary, AppColors.secondaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cultural Experiences',
                        style: AppTextStyles.h4.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Immerse yourself in authentic Tunisian culture',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to experiences
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.secondary,
                        ),
                        child: const Text('Explore Experiences'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
