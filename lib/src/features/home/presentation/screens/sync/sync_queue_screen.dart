// lib/src/features/home/presentation/screens/sync_queue_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core_ui/widgets/widgets.dart';
import '../widgets/sync/connection_status_card.dart';
import '../widgets/sync/pending_items_section.dart';
import '../widgets/sync/conflicts_section.dart';

/// Pantalla de Cola de Sincronización (Fase 1)
/// 
/// Refactorizada para usar widgets modulares:
/// - [ConnectionStatusCard]: Muestra el estado de conexión
/// - [PendingItemsSection]: Items pendientes de sincronizar
/// - [ConflictsSection]: Conflictos de sincronización
class SyncQueueScreen extends StatelessWidget {
  const SyncQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronización'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const ConnectionStatusCard(),
          const SizedBox(height: 24),
          const PendingItemsSection(),
          const SizedBox(height: 24),
          const ConflictsSection(),
          const SizedBox(height: 24),
          AppButton.primary(
            text: 'Forzar Sincronización Ahora',
            icon: Icons.sync,
            size: ButtonSize.large,
            onPressed: () {
              // TODO: Implementar sincronización forzada
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sincronizando...'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
