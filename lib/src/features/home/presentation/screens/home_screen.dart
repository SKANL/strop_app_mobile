// lib/src/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/manager/auth_provider.dart';
import '../providers/projects_provider.dart';
import '../../../../core/core_ui/widgets/widgets.dart';
import '../widgets/project_card.dart';

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
              children: [
                if (user != null) AvatarWithInitials.forRole(name: user.name, role: user.role.toString().split('.').last),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user != null ? 'Hola, ${user.name}' : 'Mis Proyectos',
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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

        // Lista de proyectos reales usando ProjectCard reusable
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final project = projects[index];
                return ProjectCard(
                  project: project,
                  onTap: () => context.push('/project/${project.id}/tabs'),
                );
              },
              childCount: projects.length,
            ),
          ),
        );
      },
    );
  }
  
  // Helper methods removed — replaced by reusable widgets (ProjectCard, AvatarWithInitials)
}
