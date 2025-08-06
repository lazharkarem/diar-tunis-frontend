import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../properties/presentation/cubit/properties_cubit.dart';

class CategoryChips extends StatefulWidget {
  final Function(Category?)? onCategorySelected;
  final Category? selectedCategory;

  const CategoryChips({
    super.key,
    this.onCategorySelected,
    this.selectedCategory,
  });

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertiesCubit, PropertiesState>(
      builder: (context, state) {
        if (state is PropertiesLoading) {
          return const SizedBox(height: 50, child: LoadingWidget());
        }

        if (state is PropertiesLoaded) {
          final categories = state.categories;

          if (categories.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Property Types',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: categories.length + 1, // +1 for "All" chip
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // "All" chip
                      return _CategoryChip(
                        label: 'All',
                        count: categories.fold<int>(
                          0,
                          (sum, category) => sum + category.propertyCount,
                        ),
                        isSelected: _selectedCategory == null,
                        onTap: () => _selectCategory(null),
                      );
                    }

                    final category = categories[index - 1];
                    return _CategoryChip(
                      label: category.name,
                      count: category.propertyCount,
                      icon: _getCategoryIcon(category.icon),
                      isSelected: _selectedCategory?.id == category.id,
                      onTap: () => _selectCategory(category),
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

  void _selectCategory(Category? category) {
    setState(() {
      _selectedCategory = category;
    });

    widget.onCategorySelected?.call(category);
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'villa':
        return Icons.villa;
      case 'apartment':
        return Icons.apartment;
      case 'house':
        return Icons.home;
      case 'riad':
        return Icons.home_work;
      case 'hotel':
        return Icons.hotel;
      default:
        return Icons.home;
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final int count;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.count,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
            Text('$label ($count)'),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        selectedColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
        ),
      ),
    );
  }
}
