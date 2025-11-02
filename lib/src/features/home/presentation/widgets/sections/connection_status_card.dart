// lib/src/features/home/presentation/widgets/sync/connection_status_card.dart
import 'package:flutter/material.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Widget que muestra el estado de conexión y sincronización.
/// 
/// Muestra:
/// - Ícono de estado (check_circle para conectado)
/// - Título "Estado de Conexión"
/// - Estado actual: "En línea - Sincronizado"
class ConnectionStatusCard extends StatelessWidget {
  const ConnectionStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.closedStatusColor,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estado de Conexión',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'En línea - Sincronizado',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.closedStatusColor,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
