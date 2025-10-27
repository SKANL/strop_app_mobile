// lib/src/features/home/presentation/widgets/project_card.dart
import 'package:flutter/material.dart';
import '../../../../core/core_domain/entities/project_entity.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Widget reutilizable para mostrar un proyecto en formato de tarjeta
class ProjectCard extends StatelessWidget {
  final ProjectEntity project;
  final VoidCallback onTap;
  final bool isArchived;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    this.isArchived = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con nombre e icono de estado
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(context),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Ubicación
              if (project.address != null)
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.iconColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        project.address!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.iconColor,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              
              const SizedBox(height: 8),
              
              // Fechas
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.iconColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateRange(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.iconColor,
                        ),
                  ),
                ],
              ),
              
              if (isArchived) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.archive_outlined,
                      size: 16,
                      color: AppColors.iconColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Proyecto archivado',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.iconColor,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (project.status) {
      case ProjectStatus.planning:
        color = AppColors.progressReportColor;
        label = 'Planificación';
        icon = Icons.edit_calendar;
        break;
      case ProjectStatus.active:
        color = AppColors.closedStatusColor;
        label = 'Activo';
        icon = Icons.play_circle_outline;
        break;
      case ProjectStatus.paused:
        color = AppColors.pendingStatusColor;
        label = 'Pausado';
        icon = Icons.pause_circle_outline;
        break;
      case ProjectStatus.completed:
        color = AppColors.inactiveStatusColor;
        label = 'Completado';
        icon = Icons.check_circle_outline;
        break;
      case ProjectStatus.cancelled:
        color = AppColors.error;
        label = 'Cancelado';
        icon = Icons.cancel_outlined;
        break;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
  backgroundColor: color.withAlpha((0.1 * 255).round()),
  side: BorderSide(color: color.withAlpha((0.3 * 255).round())),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  String _formatDateRange() {
    final start = '${project.startDate.day}/${project.startDate.month}/${project.startDate.year}';
    if (project.endDate != null) {
      final end = '${project.endDate!.day}/${project.endDate!.month}/${project.endDate!.year}';
      return '$start - $end';
    }
    return 'Desde $start';
  }
}
