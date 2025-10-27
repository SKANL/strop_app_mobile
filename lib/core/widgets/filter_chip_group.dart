import 'package:flutter/material.dart';
import '../../src/core/core_ui/theme/app_colors.dart';

/// Reusable filter chip group widget
/// 
/// Displays a horizontal scrollable list of filter chips with:
/// - Single or multiple selection
/// - Customizable styling
/// - Active state management
/// 
/// Replaces 3+ duplicated filter chip implementations
class FilterChipGroup extends StatelessWidget {
  const FilterChipGroup({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
    this.multiSelect = false,
    this.spacing = 8.0,
  });

  final List<String> options;
  final List<String> selectedOptions;
  final void Function(List<String>) onSelectionChanged;
  final bool multiSelect;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((option) {
          final bool isSelected = selectedOptions.contains(option);
          
          return Padding(
            padding: EdgeInsets.only(right: spacing),
            child: FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                List<String> newSelection;
                
                if (multiSelect) {
                  newSelection = List.from(selectedOptions);
                  if (selected) {
                    newSelection.add(option);
                  } else {
                    newSelection.remove(option);
                  }
                } else {
                  newSelection = selected ? [option] : [];
                }
                
                onSelectionChanged(newSelection);
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary.withOpacity(0.15),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.borderLight,
                width: isSelected ? 1.5 : 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Data class for filter chip with value
class FilterOption<T> {
  const FilterOption({
    required this.label,
    required this.value,
  });

  final String label;
  final T value;
}

/// Generic filter chip group with typed values
class FilterChipGroupTyped<T> extends StatelessWidget {
  const FilterChipGroupTyped({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onSelectionChanged,
    this.multiSelect = false,
    this.spacing = 8.0,
  });

  final List<FilterOption<T>> options;
  final List<T> selectedValues;
  final void Function(List<T>) onSelectionChanged;
  final bool multiSelect;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((option) {
          final bool isSelected = selectedValues.contains(option.value);
          
          return Padding(
            padding: EdgeInsets.only(right: spacing),
            child: FilterChip(
              label: Text(option.label),
              selected: isSelected,
              onSelected: (selected) {
                List<T> newSelection;
                
                if (multiSelect) {
                  newSelection = List.from(selectedValues);
                  if (selected) {
                    newSelection.add(option.value);
                  } else {
                    newSelection.remove(option.value);
                  }
                } else {
                  newSelection = selected ? [option.value] : [];
                }
                
                onSelectionChanged(newSelection);
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary.withOpacity(0.15),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.borderLight,
                width: isSelected ? 1.5 : 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
