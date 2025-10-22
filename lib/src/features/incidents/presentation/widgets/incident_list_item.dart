// lib/src/features/incidents/presentation/widgets/incident_list_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget reutilizable para mostrar un item de incidencia en listas
class IncidentListItem extends StatelessWidget {
  final String title;
  final String type;
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
              // Fila superior: Tipo y Estado
              Row(
                children: [
                  // Icono de tipo
                  _buildTypeIcon(context),
                  const SizedBox(width: 12),
                  
                  // Título
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isCritical == true)
                          Row(
                            children: [
                              Icon(Icons.warning, size: 16, color: Colors.red[700]),
                              const SizedBox(width: 4),
                              Text(
                                'CRÍTICA',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700],
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
              
              // Información adicional
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(reportedDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  
                  if (author != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.person, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'De: $author',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              
              if (assignedTo != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.assignment_ind, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Asignada a: $assignedTo',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
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

  Widget _buildTypeIcon(BuildContext context) {
    IconData icon;
    Color color;

    switch (type.toLowerCase()) {
      case 'avance':
        icon = Icons.trending_up;
        color = Colors.blue;
        break;
      case 'problema':
        icon = Icons.error_outline;
        color = Colors.orange;
        break;
      case 'consulta':
        icon = Icons.help_outline;
        color = Colors.purple;
        break;
      case 'seguridad':
        icon = Icons.shield_outlined;
        color = Colors.red;
        break;
      case 'material':
        icon = Icons.inventory_2_outlined;
        color = Colors.teal;
        break;
      default:
        icon = Icons.description;
        color = Colors.grey;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withValues(alpha: 0.1),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildStatusChip(BuildContext context, bool isClosed, bool isPending) {
    String label;
    Color color;
    IconData icon;

    if (isClosed) {
      label = 'Cerrada';
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (isPending) {
      label = 'Pendiente';
      color = Colors.orange;
      icon = Icons.pending;
    } else {
      label = 'Abierta';
      color = Colors.blue;
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
