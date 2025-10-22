// lib/features/projects/presentation/screens/project_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/main_app_bar.dart';
import '../providers/project_provider.dart';
import '../widgets/project_list_item.dart';
import '../../../../domain/entities/project_entity.dart';
import '../../../../core/widgets/list_data_view.dart';
import '../../../../core/widgets/data_state_handler.dart';
import '../../../../core/widgets/list_skeleton.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../widgets/project_detail_view.dart'; // Importa el nuevo widget

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});
  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: _ProjectListMobileView(),
      desktopBody: _ProjectListWebView(),
    );
  }
}

// WIDGET PRIVADO PARA VISTA MÓVIL
class _ProjectListMobileView extends StatelessWidget {
  const _ProjectListMobileView();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final projectProvider = context.watch<ProjectProvider>();

    return Scaffold(
      appBar: MainAppBar(
        title: 'Proyectos',
        showLogout: false, // El logout ahora está en el MainShell web
      ),
      body: ListDataView<Project>(
        isLoading: projectProvider.isLoading,
        error: projectProvider.error,
        data: projectProvider.projects,
        onRefresh: () async => context.read<ProjectProvider>().fetchProjects(),
        onRetry: () => context.read<ProjectProvider>().fetchProjects(),
        itemBuilder: (context, project, index) => ProjectListItem(
          project: project,
          onTap: () => context.push('/project/${project.id}', extra: project.name),
        ),
        emptyBuilder: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No hay proyectos.'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => context.push('/add-project'), child: const Text('Crear proyecto')),
            ],
          ),
        ),
      ),
      floatingActionButton: authProvider.isAdmin
          ? FloatingActionButton(
              onPressed: () => context.push('/add-project'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// WIDGET PRIVADO PARA VISTA WEB
class _ProjectListWebView extends StatelessWidget {
  const _ProjectListWebView();

  @override
  Widget build(BuildContext context) {
    final projectProvider = context.watch<ProjectProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proyectos'),
        automaticallyImplyLeading: false, // Sin botón de atrás
        actions: [
          if (authProvider.isAdmin)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton.icon(
                onPressed: () => context.push('/add-project'),
                icon: const Icon(Icons.add),
                label: const Text('Nuevo Proyecto'),
              ),
            )
        ],
      ),
      body: DataStateHandler<List<Project>>(
        isLoading: projectProvider.isLoading,
        error: projectProvider.error,
        data: projectProvider.projects,
        loadingBuilder: () => const ListSkeleton(),
        errorBuilder: (err) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ocurrió un error: $err', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: () => context.read<ProjectProvider>().fetchProjects(), child: const Text('Reintentar')),
              ],
            ),
          ),
        ),
        emptyBuilder: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No hay proyectos.'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: () => context.push('/add-project'), child: const Text('Crear proyecto')),
            ],
          ),
        ),
        contentBuilder: (projects) {
          return Row(
            children: [
              SizedBox(
                width: 350,
                child: ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return ProjectListItem(
                      project: project,
                      isSelected: projectProvider.selectedProject?.id == project.id,
                      onTap: () => context.read<ProjectProvider>().selectProject(project),
                    );
                  },
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: projectProvider.selectedProject != null
                    ? ProjectDetailView(project: projectProvider.selectedProject!)
                    : const Center(child: Text('Selecciona un proyecto')),
              ),
            ],
          );
        },
      ),
    );
  }
}