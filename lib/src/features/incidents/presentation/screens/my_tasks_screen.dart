// lib/src/features/incidents/presentation/screens/my_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../../../auth/presentation/manager/auth_provider.dart';
import '../providers/incidents_provider.dart';
import '../widgets/incident_list_item.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

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
      final userId = context.read<AuthProvider>().user?.id ?? '';
      context.read<IncidentsProvider>().loadMyTasks(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IncidentsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingTasks) {
          return Center(child: AppLoading());
        }

        if (provider.tasksError != null) {
          return Center(
            child: AppError(
              message: provider.tasksError ?? 'Error',
              onRetry: () => provider.loadMyTasks(context.read<AuthProvider>().user?.id ?? ''),
            ),
          );
        }

        final tasks = provider.myTasks;

        if (tasks.isEmpty) {
          return EmptyState.noTasks();
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadMyTasks(context.read<AuthProvider>().user?.id ?? ''),
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

  // Empty state replaced by reusable EmptyState.noTasks()

}
