import 'package:diar_tunis/app/themes/colors.dart';
import 'package:diar_tunis/app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  String _selectedCategory = 'all';

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'All', 'icon': Icons.grid_view, 'value': 'all'},
    {'name': 'Villas', 'icon': Icons.villa, 'value': 'villa'},
    {'name': 'Apartments', 'icon': Icons.apartment, 'value': 'apartment'},
    {'name': 'Hotels', 'icon': Icons.hotel, 'value': 'hotel'},
    {'name': 'Guesthouses', 'icon': Icons.house, 'value': 'guesthouse'},
    {'name': 'Camps', 'icon': Icons.outbond_outlined, 'value': 'camp'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category['value'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Row(
                children: [
                  Icon(category['icon'], size: 18),
                  const SizedBox(width: 8),
                  Text(category['name']),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category['value'];
                  // Implement category filter logic
                });
              },
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
          );
        },
      ),
    );
  }
}
