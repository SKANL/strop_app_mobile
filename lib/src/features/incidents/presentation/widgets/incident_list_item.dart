// lib/src/features/incidents/presentation/widgets/incident_list_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Widget reutilizable para mostrar un item de incidencia en listas
class IncidentListItem extends StatelessWidget {
  final String title;
  final IncidentType type;
  final String? author;
  final String? assignedTo;
  final DateTime reportedDate;
  final String status;
  final bool? isCritical;
  final VoidCallback onTap;

  const IncidentListItem({
    super.key,
    required this.title,
    required this.type,
    this.author,
    this.assignedTo,
    required this.reportedDate,
    required this.status,
    this.isCritical,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isClosed = status.toLowerCase() == 'cerrada';
    final isPending = status.toLowerCase() == 'pendiente';

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
              // Fila superior: Título y Estado
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isCritical == true)
                          Row(
                            children: [
                              Icon(Icons.warning, size: 16, color: AppColors.criticalStatusColor),
                              const SizedBox(width: 4),
                              Text(
                                'CRÍTICA',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.criticalStatusColor,
                                ),
                              ),
                            ],
                          ),
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Chip de estado
                  _buildStatusChip(context, isClosed, isPending),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Tipo y fecha
              Row(
                children: [
                  TypeChip(type: type),
                  const SizedBox(width: 12),
                  Icon(Icons.calendar_today, size: 14, color: AppColors.iconColor),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(reportedDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.iconColor,
                        ),
                  ),
                ],
              ),
              
              if (author != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: AppColors.iconColor),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'De: $author',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.iconColor,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              
              if (assignedTo != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.assignment_ind, size: 14, color: AppColors.iconColor),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Asignada a: $assignedTo',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.iconColor,
                            ),
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildStatusChip(BuildContext context, bool isClosed, bool isPending) {
    String label;
    Color color;
    IconData icon;

    if (isClosed) {
      label = 'Cerrada';
      color = AppColors.closedStatusColor;
      icon = Icons.check_circle;
    } else if (isPending) {
      label = 'Pendiente';
      color = AppColors.pendingStatusColor;
      icon = Icons.pending;
    } else {
      label = 'Abierta';
      color = AppColors.openStatusColor;
      icon = Icons.circle;
    }

    return Chip(
      avatar: Icon(icon, size: 14, color: color),
      label: Text(
        label,
        style: TextStyle(fontSize: 11, color: color),
      ),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color),
      backgroundColor: color.withValues(alpha: 0.1),
    );
  }
}
