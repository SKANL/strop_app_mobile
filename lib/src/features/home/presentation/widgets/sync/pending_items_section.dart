// lib/src/features/home/presentation/widgets/sync/pending_items_section.dart
import 'package:flutter/material.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Widget que muestra los items pendientes de sincronizar.
/// 
/// Si no hay items pendientes, muestra un estado vacío.
/// TODO: Cuando hay items, mostrar lista de items pendientes.
class PendingItemsSection extends StatelessWidget {
  const PendingItemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implementar con datos reales
    final hasPendingItems = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items Pendientes de Sincronizar',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (!hasPendingItems) _buildEmptyState(context),
        // TODO: Cuando hasPendingItems = true, mostrar lista de items
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: AppColors.borderColor,
            ),
            const SizedBox(height: 8),
            Text(
              'No hay items pendientes',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.iconColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
