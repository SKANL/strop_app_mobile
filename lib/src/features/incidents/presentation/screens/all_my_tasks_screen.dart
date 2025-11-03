// lib/src/features/incidents/presentation/screens/all_my_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core_ui/widgets/widgets.dart';
import '../../../../core/core_ui/theme/app_colors.dart';
import '../providers/my_tasks_provider.dart';
import '../../../auth/presentation/manager/auth_provider.dart';
import '../widgets/list_items/incident_list_item.dart';

/// Pantalla que muestra TODAS las tareas del usuario de TODOS sus proyectos
/// 
/// Flujo simplificado: Usuario toca "Mis Tareas" → Ve todas sus tareas consolidadas
class AllMyTasksScreen extends StatefulWidget {
  const AllMyTasksScreen({super.key});

  @override
  State<AllMyTasksScreen> createState() => _AllMyTasksScreenState();
}

class _AllMyTasksScreenState extends State<AllMyTasksScreen> {
  @override
  void initState() {
    super.initState();
    // Defer loading to next frame to avoid notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTasks());
  }

  void _loadTasks() {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.id ?? '';
    
    if (userId.isNotEmpty) {
      // Cargar TODAS las tareas sin filtro de proyecto (projectId vacío)
      context.read<MyTasksProvider>().loadMyTasks(userId, projectId: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implementar filtros (por proyecto, prioridad, estado)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filtros próximamente'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<MyTasksProvider>(
        builder: (context, tasksProvider, _) {
          // Loading state
          if (tasksProvider.isLoading) {
            return const Center(child: AppLoading());
          }

          // Error state
          if (tasksProvider.error != null) {
            return Center(
              child: AppError(
                message: tasksProvider.error!,
                onRetry: _loadTasks,
              ),
            );
          }

          final tasks = tasksProvider.items;

          // Empty state
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: AppColors.borderColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '¡Todo al día!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No tienes tareas pendientes',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.iconColor,
                        ),
                  ),
                ],
              ),
            );
          }

          // Lista de tareas agrupadas por proyecto
          return RefreshIndicator(
            onRefresh: () async => _loadTasks(),
            child: CustomScrollView(
              slivers: [
                // Resumen de estadísticas
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.progressReportColor.withAlpha((0.1 * 255).round()),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.progressReportColor.withAlpha((0.3 * 255).round()),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          context,
                          icon: Icons.assignment_outlined,
                          label: 'Total',
                          value: '${tasks.length}',
                          color: AppColors.progressReportColor,
                        ),
                        _buildStatItem(
                          context,
                          icon: Icons.pending_outlined,
                          label: 'Abiertas',
                          value: '${tasksProvider.pendingCount}',
                          color: AppColors.pendingStatusColor,
                        ),
                        _buildStatItem(
                          context,
                          icon: Icons.priority_high,
                          label: 'Críticas',
                          value: '${tasksProvider.criticalItems.length}',
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ),

                // Lista de tareas
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final task = tasks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: IncidentListItem(
                            title: task.title,
                            type: task.type,
                            author: task.createdBy, // Es un String (ID del usuario)
                            assignedTo: task.assignedTo, // Es un String (ID del usuario)
                            reportedDate: task.createdAt,
                            status: task.status.toString().split('.').last,
                            isCritical: task.isCritical,
                            showRelativeTime: true,
                            onTap: () => context.push(
                              '/project/${task.projectId}/incident/${task.id}',
                            ),
                          ),
                        );
                      },
                      childCount: tasks.length,
                    ),
                  ),
                ),
                
                // Espacio final
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.iconColor,
                fontSize: 11,
              ),
        ),
      ],
    );
  }
}
