// lib/src/features/home/presentation/widgets/sync/conflicts_section.dart
import 'package:flutter/material.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Widget que muestra los conflictos de sincronización.
/// 
/// Si no hay conflictos, muestra un estado vacío.
/// TODO: Cuando hay conflictos, mostrar lista de conflictos.
class ConflictsSection extends StatelessWidget {
  const ConflictsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implementar con datos reales
    final hasConflicts = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Conflictos de Sincronización',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (!hasConflicts) _buildEmptyState(context),
        // TODO: Cuando hasConflicts = true, mostrar lista de conflictos
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
              Icons.sentiment_satisfied_outlined,
              size: 48,
              color: AppColors.borderColor,
            ),
            const SizedBox(height: 8),
            Text(
              'No hay conflictos',
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
