// lib/src/core/core_ui/widgets/filter_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

/// Widget reutilizable para Bottom Sheet de filtros.
/// 
/// Proporciona una interfaz consistente para aplicar filtros en listas.
/// 
/// Ejemplo de uso:
/// ```dart
/// FilterBottomSheet.show(
///   context: context,
///   title: 'Filtrar Reportes',
///   filterGroups: [
///     FilterGroup(
///       title: 'Estado',
///       options: ['Abierta', 'Cerrada'],
///       selectedOptions: _statusFilters,
///       onChanged: (selected) => setState(() => _statusFilters = selected),
///     ),
///   ],
///   onApply: () {
///     // Aplicar filtros
///     Navigator.pop(context);
///   },
///   onClear: () {
///     // Limpiar filtros
///   },
/// )
/// ```
class FilterBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<FilterGroup> filterGroups,
    required VoidCallback onApply,
    VoidCallback? onClear,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
  backgroundColor: AppColors.transparent,
      builder: (context) => _FilterBottomSheetContent(
        title: title,
        filterGroups: filterGroups,
        onApply: onApply,
        onClear: onClear,
      ),
    );
  }
}

class _FilterBottomSheetContent extends StatelessWidget {
  final String title;
  final List<FilterGroup> filterGroups;
  final VoidCallback onApply;
  final VoidCallback? onClear;

  const _FilterBottomSheetContent({
    required this.title,
    required this.filterGroups,
    required this.onApply,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.8;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
              decoration: BoxDecoration(
              color: AppColors.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (onClear != null)
                  TextButton(
                    onPressed: onClear,
                    child: const Text('Limpiar'),
                  ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Filter groups
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: filterGroups.map((group) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildFilterGroup(context, group),
                  );
                }).toList(),
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.withOpacity(AppColors.black, 0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onApply,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Aplicar Filtros'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterGroup(BuildContext context, FilterGroup group) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group title
        Text(
          group.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Options
        ...group.options.map((option) {
          final isSelected = group.selectedOptions.contains(option);
          return CheckboxListTile(
            value: isSelected,
            onChanged: (value) {
              if (value == true) {
                group.onChanged(
                  [...group.selectedOptions, option],
                );
              } else {
                group.onChanged(
                  group.selectedOptions.where((o) => o != option).toList(),
                );
              }
            },
            title: Text(option),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
      ],
    );
  }
}

/// Modelo para un grupo de filtros
class FilterGroup {
  final String title;
  final List<String> options;
  final List<String> selectedOptions;
  final Function(List<String>) onChanged;

  FilterGroup({
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onChanged,
  });
}
