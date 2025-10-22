// lib/src/features/home/presentation/screens/archived_projects_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de Proyectos Archivados (Fase 3)
class ArchivedProjectsScreen extends StatelessWidget {
  const ArchivedProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyectos Archivados'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildProjectsList(context),
    );
  }

  Widget _buildProjectsList(BuildContext context) {
    // TODO: Implementar con datos reales del provider
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.archive_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay proyectos archivados',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los proyectos completados o cancelados\naparecerán aquí',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
