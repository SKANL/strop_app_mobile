// lib/src/features/home/presentation/screens/sync_queue_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de Cola de Sincronización (Fase 1)
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
          // Estado de conexión
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green[600],
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
                                color: Colors.green[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Sección de pendientes
          Text(
            'Items Pendientes de Sincronizar',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          
          _buildPendingSection(context),
          
          const SizedBox(height: 24),
          
          // Sección de conflictos
          Text(
            'Conflictos de Sincronización',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          
          _buildConflictsSection(context),
          
          const SizedBox(height: 24),
          
          // Botón de sincronización forzada
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implementar sincronización forzada
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sincronizando...'),
                ),
              );
            },
            icon: const Icon(Icons.sync),
            label: const Text('Forzar Sincronización Ahora'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingSection(BuildContext context) {
    // TODO: Implementar con datos reales
    final hasPendingItems = false;

    if (!hasPendingItems) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'No hay items pendientes',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // TODO: Cuando hasPendingItems = true, mostrar lista de items
  }

  Widget _buildConflictsSection(BuildContext context) {
    // TODO: Implementar con datos reales
    final hasConflicts = false;

    if (!hasConflicts) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                Icons.sentiment_satisfied_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'No hay conflictos',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      );
    }

    // TODO: Cuando hasConflicts = true, mostrar lista de conflictos
  }
}
