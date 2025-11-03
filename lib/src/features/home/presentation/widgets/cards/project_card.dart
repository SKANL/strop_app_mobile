// lib/src/features/home/presentation/widgets/cards/project_card.dart
import 'package:flutter/material.dart';
import '../../../../../core/core_domain/entities/project_entity.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderColor, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Row(
            children: [
              // Nombre del proyecto
              Expanded(
                child: Text(
                  project.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Status badge compacto
              _buildCompactStatusBadge(context),
              
              const SizedBox(width: 4),
              
              // Icono de navegación
              Icon(
                Icons.chevron_right,
                color: AppColors.iconColor,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactStatusBadge(BuildContext context) {
    Color color;
    String label;

    switch (project.status) {
      case ProjectStatus.planning:
        color = AppColors.progressReportColor;
        label = 'Plan';
        break;
      case ProjectStatus.active:
        color = AppColors.closedStatusColor;
        label = 'Activo';
        break;
      case ProjectStatus.paused:
        color = AppColors.pendingStatusColor;
        label = 'Pausado';
        break;
      case ProjectStatus.completed:
        color = AppColors.inactiveStatusColor;
        label = 'Completado';
        break;
      case ProjectStatus.cancelled:
        color = AppColors.error;
        label = 'Cancelado';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha((0.3 * 255).round())),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
