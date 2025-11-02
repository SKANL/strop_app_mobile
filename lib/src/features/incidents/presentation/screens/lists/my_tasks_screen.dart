// lib/src/features/incidents/presentation/screens/lists/my_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/core_domain/entities/data_state.dart';
import '../../../../../core/core_domain/entities/incident_entity.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../../providers/incidents_list_provider.dart';
import '../../widgets/list_items/incident_list_item.dart';
import '../../helpers/incident_helpers.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

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
      context.read<IncidentsListProvider>().loadMyTasks(userId);
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
                return context.read<IncidentsListProvider>().loadMyTasks(userId);
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
                  context.read<IncidentsListProvider>().loadMyTasks(userId);
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
          status: IncidentHelpers.getStatusLabel(task.status),
          isCritical: task.priority == IncidentPriority.critical,
          onTap: () {
            context.push('/incident/${task.id}');
          },
        );
      },
    );
  }

  // Empty state replaced by reusable EmptyState.noTasks()

}
