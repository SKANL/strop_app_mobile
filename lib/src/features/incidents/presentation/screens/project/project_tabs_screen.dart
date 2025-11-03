// lib/src/features/incidents/presentation/screens/project/project_tabs_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../lists/my_tasks_screen.dart';
import '../lists/my_reports_screen.dart';
import 'project_bitacora_screen.dart';
import '../../widgets/dialogs/quick_incident_type_selector.dart';

/// Pantalla de Tabs del Proyecto (Fase 2)
/// Centro de trabajo principal con navegación por tabs: Mis Tareas, Mis Reportes, Bitácora
/// 
/// Modo Archivo (Screen 24):
/// - Si isArchived = true, oculta el FAB
/// - En IncidentDetailScreen, se ocultan los botones de acción
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

class _ProjectTabsScreenState extends State<ProjectTabsScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Proyecto 1'),
            Text(
              'Torre Centenario - CDMX',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Botón de equipo
          IconButton(
            icon: const Icon(Icons.people_outline),
            tooltip: 'Equipo del proyecto',
            onPressed: () {
              context.push('/project/${widget.projectId}/team');
            },
          ),
          // Botón de información del proyecto
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Información del proyecto',
            onPressed: () {
              context.push('/project/${widget.projectId}/info');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.task_outlined),
              text: 'Mis Tareas',
            ),
            Tab(
              icon: Icon(Icons.report_outlined),
              text: 'Mis Reportes',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'Bitácora',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MyTasksScreen(projectId: widget.projectId),
          MyReportsScreen(projectId: widget.projectId),
          ProjectBitacoraScreen(projectId: widget.projectId),
        ],
      ),
      // Ocultar FAB en modo archivo (Screen 24)
      floatingActionButton: widget.isArchived ? null : FloatingActionButton.extended(
        onPressed: () => _showQuickIncidentCreator(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Reporte'),
      ),
    );
  }
  
  /// Muestra el selector rápido de tipo de incidencia (BottomSheet)
  /// Reemplaza la navegación a SelectIncidentTypeScreen
  void _showQuickIncidentCreator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangeNotifierProvider.value(
        value: context.read<AuthProvider>(),
        child: QuickIncidentTypeSelector(
          projectId: widget.projectId,
        ),
      ),
    );
  }
}
