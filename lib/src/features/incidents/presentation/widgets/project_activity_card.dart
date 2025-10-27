import 'package:flutter/material.dart';
import '../../../../core/core_ui/theme/app_colors.dart';

/// Widget para mostrar una actividad del programa del proyecto
class ProjectActivityCard extends StatelessWidget {
  final String title;
  final String startDate;
  final String endDate;
  final int progress;
  final String status;

  const ProjectActivityCard({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.progress,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Completado':
        statusColor = AppColors.closedStatusColor;
        break;
      case 'En Progreso':
        statusColor = AppColors.openStatusColor;
        break;
      default:
        statusColor = AppColors.inactiveStatusColor;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Chip(
                  label: Text(
                    status,
                    style: TextStyle(fontSize: 11, color: statusColor),
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: statusColor),
                  backgroundColor: statusColor.withValues(alpha: 0.1),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Fechas
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: AppColors.iconColor),
                const SizedBox(width: 4),
                Text(
                  '$startDate - $endDate',
                  style: TextStyle(fontSize: 12, color: AppColors.iconColor),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Barra de progreso
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso',
                      style: TextStyle(fontSize: 12, color: AppColors.iconColor),
                    ),
                    Text(
                      '$progress%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: AppColors.lighten(AppColors.iconColor, 0.9),
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
