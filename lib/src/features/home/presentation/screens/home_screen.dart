// lib/src/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/manager/auth_provider.dart';
import '../providers/projects_provider.dart';
import '../../../../core/core_ui/widgets/app_loading.dart';
import '../../../../core/core_ui/widgets/app_error.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar proyectos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsProvider>().loadActiveProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;
        
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    user != null ? 'Hola, ${user.name}' : 'Mis Proyectos',
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (user != null) ...[
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      _getRoleLabel(user.role),
                      style: const TextStyle(fontSize: 11),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.push('/notifications'),
                tooltip: 'Notificaciones',
              ),
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () => context.push('/settings'),
                tooltip: 'Configuración',
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // TODO: Implementar refresh de proyectos
              await Future.delayed(const Duration(seconds: 1));
            },
            child: CustomScrollView(
              slivers: [
                // Sección de proyectos activos
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Mis Proyectos Activos',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                
                // Lista de proyectos (placeholder por ahora)
                _buildProjectsList(context),
                
                // Botón para ver proyectos archivados
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/archived-projects'),
                      icon: const Icon(Icons.archive_outlined),
                      label: const Text('Ver Proyectos Archivados'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectsList(BuildContext context) {
    return Consumer<ProjectsProvider>(
      builder: (context, projectsProvider, _) {
        // Loading state
        if (projectsProvider.isLoadingActive) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: AppLoading()),
          );
        }

        // Error state
        if (projectsProvider.activeError != null) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: AppError(
                message: 'Error al cargar proyectos',
                onRetry: () => projectsProvider.loadActiveProjects(),
              ),
            ),
          );
        }

        final projects = projectsProvider.activeProjects;

        // Empty state
        if (projects.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aún no tienes proyectos asignados',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Los proyectos asignados aparecerán aquí',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        // Lista de proyectos reales
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final project = projects[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: () {
                      // Navegar a ProjectTabsScreen con ID real
                      context.push('/project/${project.id}/tabs');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título y estado
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  project.name,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              _buildStatusChip(context, project.status.name),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (project.description.isNotEmpty)
                            Text(
                              project.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  project.address ?? 'Sin dirección',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                'Inicio: ${_formatDate(project.startDate)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: projects.length,
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildStatusChip(BuildContext context, String status) {
    Color color;
    IconData icon;
    
    switch (status.toLowerCase()) {
      case 'activo':
        color = Colors.green;
        icon = Icons.play_circle_outline;
        break;
      case 'pausado':
        color = Colors.orange;
        icon = Icons.pause_circle_outline;
        break;
      case 'completado':
        color = Colors.blue;
        icon = Icons.check_circle_outline;
        break;
      default:
        color = Colors.grey;
        icon = Icons.circle_outlined;
    }
    
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        status,
        style: TextStyle(fontSize: 12, color: color),
      ),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color),
      backgroundColor: color.withValues(alpha: 0.1),
    );
  }

  String _getRoleLabel(dynamic role) {
    final roleStr = role.toString().split('.').last;
    switch (roleStr) {
      case 'superadmin':
        return 'Super Admin';
      case 'owner':
        return 'Dueño';
      case 'superintendent':
        return 'Superintendente';
      case 'resident':
        return 'Residente';
      case 'cabo':
        return 'Cabo';
      default:
        return roleStr;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
