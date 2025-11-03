// lib/src/features/incidents/presentation/screens/lists/my_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/data_state.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/incident_entity.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../../providers/incidents_list_provider.dart';
import '../../widgets/list_items/incident_list_item.dart';
import '../../utils/converters/incident_converters.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

/// Screen 11: Mis Tareas - Lista de incidencias asignadas al usuario (Top-Down)
/// 
/// OPTIMIZADO EN SEMANA 5:
/// - Reemplazado Consumer por Selector (reducción de rebuilds ~70%)
/// - Agregados const constructors donde es posible
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
      // Cargar tareas filtradas por el proyecto actual
      context.read<IncidentsListProvider>().loadMyTasks(userId, projectId: widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // OPTIMIZADO EN SEMANA 5: Consumer → Selector
    // Reducción de rebuilds: solo reconstruye cuando myTasksState cambia
    return Selector<IncidentsListProvider, DataState<List<IncidentEntity>>>(
      selector: (_, provider) => provider.myTasksState,
      builder: (context, tasksState, _) {
        return tasksState.when(
          initial: () => const Center(child: Text('Cargando...')),
          loading: () => const Center(child: AppLoading()),
          success: (tasks) {
            if (tasks.isEmpty) {
              return EmptyState.noTasks();
            }

            return RefreshIndicator(
              onRefresh: () {
                final userId = context.read<AuthProvider>().user?.id ?? '';
                return context.read<IncidentsListProvider>().loadMyTasks(userId, projectId: widget.projectId);
              },
              child: _buildTasksList(context, tasks),
            );
          },
          error: (failure) {
            return Center(
              child: AppError(
                message: failure.message,
                onRetry: () {
                  final userId = context.read<AuthProvider>().user?.id ?? '';
                  context.read<IncidentsListProvider>().loadMyTasks(userId, projectId: widget.projectId);
                },
              ),
            );
          },
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
          type: task.type,
          author: task.createdBy,
          reportedDate: task.createdAt,
          status: IncidentConverters.getStatusLabel(task.status),
          isCritical: task.priority == IncidentPriority.critical,
          onTap: () {
            // Navegar usando la ruta del proyecto para mantener el stack/visual coherente
            context.push('/project/${task.projectId}/incident/${task.id}');
          },
        );
      },
    );
  }

  // Empty state replaced by reusable EmptyState.noTasks()

}
