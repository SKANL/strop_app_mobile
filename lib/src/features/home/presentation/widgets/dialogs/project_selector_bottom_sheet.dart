// lib/src/features/home/presentation/widgets/dialogs/project_selector_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';
import '../../../../../core/core_domain/entities/project_entity.dart';
import '../../providers/projects_provider.dart';
import '../../../../incidents/presentation/widgets/dialogs/quick_incident_type_selector.dart';

/// BottomSheet para seleccionar un proyecto antes de crear un reporte rápido
/// 
/// Flujo: Usuario toca "Nuevo Reporte" → Selecciona Proyecto → Selecciona Tipo → Crea
class ProjectSelectorBottomSheet extends StatelessWidget {
  /// parentContext es el contexto del widget que abrió el BottomSheet
  /// se usa para abrir otro BottomSheet o navegar después de cerrar este.
  final BuildContext parentContext;

  const ProjectSelectorBottomSheet({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Título
          Text(
            'Selecciona un proyecto',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Elige el proyecto para crear el reporte',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.iconColor,
                ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Lista de proyectos
          _buildProjectsList(context),
          
          const SizedBox(height: 16),
          
          // Botón cancelar
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Cancelar'),
          ),
          
          // Espacio para safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildProjectsList(BuildContext context) {
    return Consumer<ProjectsProvider>(
      builder: (context, projectsProvider, _) {
        // Loading state
        if (projectsProvider.isLoadingActive) {
          return const SizedBox(
            height: 100,
            child: Center(child: AppLoading()),
          );
        }

        // Error state
        if (projectsProvider.activeError != null) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Text(
                'Error al cargar proyectos',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          );
        }

        final projects = projectsProvider.activeProjects;

        // Empty state
        if (projects.isEmpty) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_off_outlined,
                    size: 40,
                    color: AppColors.iconColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No tienes proyectos asignados',
                    style: TextStyle(color: AppColors.iconColor),
                  ),
                ],
              ),
            ),
          );
        }

        // Lista de proyectos (máximo 5 para no hacer el bottom sheet muy largo)
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: projects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final project = projects[index];
              return _buildProjectOption(context, project);
            },
          ),
        );
      },
    );
  }

  Widget _buildProjectOption(BuildContext context, ProjectEntity project) {
    return InkWell(
      onTap: () {
        // Cerrar este BottomSheet
        Navigator.pop(context);

        // Esperar un pequeño delay para asegurarnos que el bottom sheet
        // haya cerrado antes de abrir el siguiente. Usamos el contexto padre
        // que pasó el caller para abrir el siguiente BottomSheet.
        Future.delayed(const Duration(milliseconds: 200), () {
          // Verificar que el context padre siga montado antes de usarlo
          if (!parentContext.mounted) return;
          
          showModalBottomSheet(
            context: parentContext,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (c) => QuickIncidentTypeSelector(
              projectId: project.id,
            ),
          );
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: [
            // Icono
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getStatusColor(project.status).withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.folder_outlined,
                color: _getStatusColor(project.status),
                size: 20,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Nombre
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getStatusLabel(project.status),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getStatusColor(project.status),
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
            
            // Icono de navegación
            Icon(
              Icons.chevron_right,
              color: AppColors.iconColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.planning:
        return AppColors.progressReportColor;
      case ProjectStatus.active:
        return AppColors.closedStatusColor;
      case ProjectStatus.paused:
        return AppColors.pendingStatusColor;
      case ProjectStatus.completed:
        return AppColors.inactiveStatusColor;
      case ProjectStatus.cancelled:
        return AppColors.error;
    }
  }

  String _getStatusLabel(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.planning:
        return 'Planificación';
      case ProjectStatus.active:
        return 'Activo';
      case ProjectStatus.paused:
        return 'Pausado';
      case ProjectStatus.completed:
        return 'Completado';
      case ProjectStatus.cancelled:
        return 'Cancelado';
    }
  }
}
