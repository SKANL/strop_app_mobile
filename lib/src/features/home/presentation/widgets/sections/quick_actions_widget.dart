// lib/src/features/home/presentation/widgets/sections/quick_actions_widget.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/core_ui/theme/app_colors.dart';
import '../dialogs/project_selector_bottom_sheet.dart';
import '../../providers/projects_provider.dart';
import '../../../../incidents/presentation/providers/my_tasks_provider.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';

/// Widget de acciones rápidas para el HomeScreen
/// 
/// **DISEÑO OPTIMIZADO PARA AGILIZAR REGISTRO DE INCIDENCIAS**
/// 
/// Proporciona acceso directo y visualmente destacado a:
/// - **Crear nuevo reporte** (ACCIÓN PRINCIPAL): Botón héroe con gradiente y sombra
/// - **Mis tareas pendientes**: Con contador en tiempo real
/// - **Notificaciones**: Acceso rápido a alertas
/// 
/// FLUJO DE CREACIÓN DE REPORTE:
/// 1. Usuario toca botón grande "Crear Nuevo Reporte"
/// 2. Se abre bottom sheet con lista de proyectos (ProjectSelectorBottomSheet)
/// 3. Usuario selecciona proyecto
/// 4. Se abre segundo bottom sheet con tipos de reporte (QuickIncidentTypeSelector)
/// 5. Usuario selecciona tipo
/// 6. Navega a formulario completo (CreateIncidentFormScreen)
/// 
/// TIEMPO ESTIMADO: ~30 segundos desde Home hasta enviar reporte
class QuickActionsWidget extends StatefulWidget {
  const QuickActionsWidget({super.key});

  @override
  State<QuickActionsWidget> createState() => _QuickActionsWidgetState();
}

class _QuickActionsWidgetState extends State<QuickActionsWidget> {
  @override
  void initState() {
    super.initState();
    // Defer loading until after the first frame to avoid calling
    // notifyListeners() during the widget build phase.
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTaskCount());
  }

  void _loadTaskCount() {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.id ?? '';
    
    if (userId.isNotEmpty) {
      // Cargar tareas para obtener el conteo real
      context.read<MyTasksProvider>().loadMyTasks(userId, projectId: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título de la sección
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.flash_on,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Acciones Rápidas',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Consumer<MyTasksProvider>(
            builder: (context, tasksProvider, _) {
              final pendingTasksCount = tasksProvider.pendingCount;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ACCIÓN PRINCIPAL: Crear Nuevo Reporte (Extra Destacado)
                  _HeroQuickActionButton(
                    icon: Icons.add_circle,
                    iconColor: AppColors.progressReportColor,
                    label: 'Crear Nuevo Reporte',
                    subtitle: 'Registra incidencias en segundos',
                    onTap: () => _showProjectSelector(context),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Acciones Secundarias: Mis Tareas y Notificaciones
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.task_alt,
                          iconColor: AppColors.problemColor,
                          label: 'Mis Tareas',
                          badge: pendingTasksCount > 0 ? '$pendingTasksCount' : null,
                          onTap: () {
                            try {
                              context.push('/all-my-tasks');
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.notifications_active,
                          iconColor: AppColors.materialRequestColor,
                          label: 'Notificaciones',
                          onTap: () {
                            try {
                              context.push('/notifications');
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showProjectSelector(BuildContext context) {
    // Capturar el ProjectsProvider ANTES de abrir el bottom sheet
    final projectsProvider = context.read<ProjectsProvider>();
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => ChangeNotifierProvider.value(
        value: projectsProvider,
        child: ProjectSelectorBottomSheet(parentContext: parentContext),
      ),
    );
  }
}

/// Botón héroe extra grande para la acción principal (Crear Nuevo Reporte)
class _HeroQuickActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _HeroQuickActionButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                iconColor,
                iconColor.withAlpha((0.8 * 255).round()),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: iconColor.withAlpha((0.4 * 255).round()),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Icono grande
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.2 * 255).round()),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                
                const SizedBox(width: 20),
                
                // Texto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withAlpha((0.9 * 255).round()),
                            ),
                      ),
                    ],
                  ),
                ),
                
                // Flecha
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Card individual para acción rápida
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono con badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 28,
                  ),
                ),
                
                // Badge
                if (badge != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.criticalStatusColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Label
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
