// lib/src/features/home/presentation/widgets/settings/sync_status_section.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Widget que muestra el estado de sincronización en la pantalla de configuración.
/// 
/// Incluye:
/// - Ícono de sincronización
/// - Estado actual (Sincronizado)
/// - Navegación a la cola de sincronización
class SyncStatusSection extends StatelessWidget {
  const SyncStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Sincronización',
      child: ListTile(
        leading: const Icon(Icons.sync),
        title: const Text('Estado de Sincronización'),
        subtitle: Row(
          children: [
            Icon(
              Icons.check_circle,
              size: 16,
              color: AppColors.closedStatusColor,
            ),
            const SizedBox(width: 4),
            const Text('Sincronizado'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => context.push('/sync-queue'),
      ),
    );
  }
}
