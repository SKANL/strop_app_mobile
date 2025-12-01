// lib/src/features/incidents/presentation/screens/project/project_tabs_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import 'package:mobile_strop_app/src/core/core_ui/theme/app_colors.dart';
import '../../../../home/presentation/widgets/dialogs/project_selector_bottom_sheet.dart';
import '../../../../home/presentation/providers/projects_provider.dart';
import '../lists/my_tasks_screen.dart';
import '../lists/my_reports_screen.dart';
import 'project_bitacora_screen.dart';
import '../../widgets/dialogs/quick_incident_type_selector.dart';
import '../../widgets/dashboard/project_dashboard_widgets.dart';

/// Pantalla de Tabs del Proyecto (Fase 8 UI/UX Overhaul)
///
/// CAMBIOS:
/// - Tab 1 ("Resumen") ahora es un Dashboard completo
/// - Integración de ProjectHeader, QuickAccessCards y BitacoraPreview
class ProjectTabsScreen extends StatefulWidget {
  final String projectId;
  final bool isArchived;

  const ProjectTabsScreen({
    super.key,
    required this.projectId,
    this.isArchived = false,
  });

  @override
  State<ProjectTabsScreen> createState() => _ProjectTabsScreenState();
}

class _ProjectTabsScreenState extends State<ProjectTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Simulación de datos del proyecto (esto debería venir de un provider real)
    const projectName = 'Torre Centenario';
    const projectLocation = 'CDMX, México';

    return Scaffold(
      appBar: AppBar(
        // Project Switcher en el título
        title: InkWell(
          onTap: () => _showProjectSelector(context),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          projectName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    Text(
                      projectLocation,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onPrimaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline),
            tooltip: 'Equipo',
            onPressed: () => context.push('/project/${widget.projectId}/team'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Configuración',
            onPressed: () {
              // TODO: Navegar a configuración del proyecto
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.iconColor,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard_outlined), text: 'Dashboard'),
            Tab(icon: Icon(Icons.folder_open_outlined), text: 'Reportes'),
            Tab(icon: Icon(Icons.history_edu_outlined), text: 'Bitácora'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Dashboard Completo
          _buildDashboardTab(context, projectName, projectLocation),
          // Tab 2: Reportes
          MyReportsScreen(projectId: widget.projectId),
          // Tab 3: Bitácora
          ProjectBitacoraScreen(projectId: widget.projectId),
        ],
      ),
      floatingActionButton: widget.isArchived
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showQuickIncidentCreator(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add_comment_outlined, color: Colors.white),
              label: const Text(
                'Reportar',
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }

  Widget _buildDashboardTab(
    BuildContext context,
    String name,
    String location,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header del Proyecto
          ProjectHeader(
            projectName: name,
            location: location,
            progress: 0.65, // Simulado
            status: 'EN PROGRESO',
            deliveryDate: '15 Dic 2024',
          ),

          const SizedBox(height: 24),

          // 2. Accesos Rápidos
          QuickAccessCards(
            onProgramTap: () =>
                context.push('/project/${widget.projectId}/info'),
            onMaterialsTap: () => context.push(
              '/project/${widget.projectId}/info',
            ), // TODO: Tab específico
          ),

          const SizedBox(height: 24),

          // 3. Mis Tareas (Resumen)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mis Tareas Pendientes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              TextButton(
                onPressed: () {
                  // Navegar a vista completa de tareas
                  context.push('/all-my-tasks');
                },
                child: const Text('Ver Todas'),
              ),
            ],
          ),
          // Usamos MyTasksScreen pero con altura limitada para que parezca un widget
          SizedBox(
            height: 250,
            child: MyTasksScreen(projectId: widget.projectId),
          ),

          const SizedBox(height: 24),

          // 4. Bitácora Preview
          BitacoraPreview(
            onViewAll: () {
              _tabController.animateTo(2); // Ir al tab de Bitácora
            },
          ),

          const SizedBox(height: 80), // Espacio para FAB
        ],
      ),
    );
  }

  void _showProjectSelector(BuildContext context) {
    final projectsProvider = context.read<ProjectsProvider>();
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangeNotifierProvider.value(
        value: projectsProvider,
        child: ProjectSelectorBottomSheet(parentContext: parentContext),
      ),
    );
  }

  void _showQuickIncidentCreator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangeNotifierProvider.value(
        value: context.read<AuthProvider>(),
        child: QuickIncidentTypeSelector(projectId: widget.projectId),
      ),
    );
  }
}
