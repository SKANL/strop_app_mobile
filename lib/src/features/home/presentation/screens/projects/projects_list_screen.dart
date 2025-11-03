// lib/src/features/home/presentation/screens/projects/projects_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/projects_provider.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';
import '../../widgets/cards/project_card.dart';

/// Pantalla para ver todos los proyectos del usuario
/// 
/// Incluye filtros y búsqueda para facilitar la navegación
class ProjectsListScreen extends StatefulWidget {
  const ProjectsListScreen({super.key});

  @override
  State<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Cargar proyectos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsProvider>().loadActiveProjects();
      context.read<ProjectsProvider>().loadArchivedProjects();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Proyectos'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Barra de búsqueda
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar proyecto...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              
              // Tabs
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Activos'),
                  Tab(text: 'Archivados'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveProjectsList(),
          _buildArchivedProjectsList(),
        ],
      ),
    );
  }

  Widget _buildActiveProjectsList() {
    return Consumer<ProjectsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingActive) {
          return const Center(child: AppLoading());
        }

        if (provider.activeError != null) {
          return Center(
            child: AppError(
              message: 'Error al cargar proyectos',
              onRetry: () => provider.loadActiveProjects(),
            ),
          );
        }

        final projects = provider.activeProjects
            .where((p) => p.name.toLowerCase().contains(_searchQuery))
            .toList();

        if (projects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _searchQuery.isEmpty 
                      ? Icons.folder_open_outlined 
                      : Icons.search_off,
                  size: 64,
                  color: AppColors.borderColor,
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isEmpty
                      ? 'No tienes proyectos activos'
                      : 'No se encontraron proyectos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.iconColor,
                      ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadActiveProjects(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return ProjectCard(
                project: project,
                onTap: () => context.push('/project/${project.id}/tabs'),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildArchivedProjectsList() {
    return Consumer<ProjectsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingArchived) {
          return const Center(child: AppLoading());
        }

        if (provider.archivedError != null) {
          return Center(
            child: AppError(
              message: 'Error al cargar proyectos archivados',
              onRetry: () => provider.loadArchivedProjects(),
            ),
          );
        }

        final projects = provider.archivedProjects
            .where((p) => p.name.toLowerCase().contains(_searchQuery))
            .toList();

        if (projects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _searchQuery.isEmpty 
                      ? Icons.archive_outlined 
                      : Icons.search_off,
                  size: 64,
                  color: AppColors.borderColor,
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isEmpty
                      ? 'No hay proyectos archivados'
                      : 'No se encontraron proyectos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.iconColor,
                      ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadArchivedProjects(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return ProjectCard(
                project: project,
                isArchived: true,
                onTap: () => context.push(
                  '/project/${project.id}/tabs?archived=true',
                ),
              );
            },
          ),
        );
      },
    );
  }
}
