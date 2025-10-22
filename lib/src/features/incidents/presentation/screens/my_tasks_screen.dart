// lib/src/features/incidents/presentation/screens/my_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../providers/incidents_provider.dart';
import '../widgets/incident_list_item.dart';

/// Screen 11: Mis Tareas - Lista de incidencias asignadas al usuario (Top-Down)
class MyTasksScreen extends StatefulWidget {
  final String projectId;

  const MyTasksScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncidentsProvider>().loadMyTasks('user-cabo-001');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IncidentsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingTasks) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.tasksError != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar tareas',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(provider.tasksError!),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => provider.loadMyTasks('user-cabo-001'),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final tasks = provider.myTasks;

        if (tasks.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadMyTasks('user-cabo-001'),
          child: _buildTasksList(context, tasks),
        );
      },
    );
  }

  Widget _buildTasksList(BuildContext context, List tasks) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return IncidentListItem(
          title: task.title,
          type: _getTypeLabel(task.type),
          author: task.createdBy,
          reportedDate: task.createdAt,
          status: _getStatusLabel(task.status),
          isCritical: task.priority == IncidentPriority.critical,
          onTap: () {
            context.push('/incident/${task.id}');
          },
        );
      },
    );
  }

  String _getTypeLabel(IncidentType type) {
    switch (type) {
      case IncidentType.progressReport:
        return 'Avance';
      case IncidentType.problem:
        return 'Problema';
      case IncidentType.consultation:
        return 'Consulta';
      case IncidentType.safetyIncident:
        return 'Seguridad';
      case IncidentType.materialRequest:
        return 'Material';
    }
  }

  String _getStatusLabel(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.open:
        return 'Abierta';
      case IncidentStatus.closed:
        return 'Cerrada';
    }
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
