// lib/src/features/incidents/presentation/screens/my_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/incident_list_item.dart';

/// Screen 11: Mis Tareas - Lista de incidencias asignadas al usuario (Top-Down)
class MyTasksScreen extends StatelessWidget {
  final String projectId;

  const MyTasksScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implementar con Provider para datos reales
    final hasTasks = false; // Cambiar según Provider

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implementar refresh desde Provider
        await Future.delayed(const Duration(seconds: 1));
      },
      child: hasTasks ? _buildTasksList(context) : _buildEmptyState(context),
    );
  }

  Widget _buildTasksList(BuildContext context) {
    // Datos de ejemplo
    final tasks = [
      {
        'id': '1',
        'title': 'Reparar fuga en P1',
        'type': 'Problema',
        'author': 'Residente García',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'Abierta',
        'critical': true,
      },
      {
        'id': '2',
        'title': 'Revisar instalación eléctrica',
        'type': 'Consulta',
        'author': 'Superintendente López',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'status': 'Abierta',
        'critical': false,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return IncidentListItem(
          title: task['title'] as String,
          type: task['type'] as String,
          author: task['author'] as String,
          reportedDate: task['date'] as DateTime,
          status: task['status'] as String,
          isCritical: task['critical'] as bool,
          onTap: () {
            context.push('/incident/${task['id']}');
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const SizedBox(height: 80),
        Icon(
          Icons.task_alt,
          size: 80,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 24),
        Text(
          'No tienes tareas asignadas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Cuando el Residente o Superintendente te asigne una tarea, aparecerá aquí.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Icon(
          Icons.lightbulb_outline,
          color: Colors.blue[300],
          size: 40,
        ),
        const SizedBox(height: 12),
        Text(
          'Tip: Las tareas aparecen cuando alguien te delega una incidencia que fue reportada por otra persona.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.blue[700],
                fontStyle: FontStyle.italic,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
