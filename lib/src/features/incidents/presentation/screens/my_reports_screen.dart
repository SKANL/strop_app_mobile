// lib/src/features/incidents/presentation/screens/my_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen 12: Mis Reportes - Lista de incidencias creadas por el usuario (Bottom-Up)
class MyReportsScreen extends StatelessWidget {
  final String projectId;

  const MyReportsScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implementar con Provider para datos reales
    final hasReports = false; // Cambiar según Provider

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implementar refresh desde Provider
        await Future.delayed(const Duration(seconds: 1));
      },
      child: hasReports ? _buildReportsList(context) : _buildEmptyState(context),
    );
  }

  Widget _buildReportsList(BuildContext context) {
    // Datos de ejemplo con estados de aprobación
    final reports = [
      {
        'id': '1',
        'title': 'Solicitud de cemento adicional',
        'type': 'Material',
        'date': DateTime.now().subtract(const Duration(hours: 5)),
        'status': 'Pendiente',
        'approvalStatus': 'PENDIENTE',
        'critical': false,
      },
      {
        'id': '2',
        'title': 'Reporte de avance Planta 1',
        'type': 'Avance',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'Cerrada',
        'approvalStatus': 'APROBADA',
        'critical': false,
      },
      {
        'id': '3',
        'title': 'Consulta sobre especificación',
        'type': 'Consulta',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'status': 'Abierta',
        'approvalStatus': 'RECHAZADA',
        'critical': false,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return _buildReportCard(context, report);
      },
    );
  }

  Widget _buildReportCard(BuildContext context, Map<String, dynamic> report) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          context.push('/incident/${report['id']}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y estado de aprobación
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      report['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildApprovalBadge(context, report['approvalStatus'] as String),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Tipo y fecha
              Row(
                children: [
                  _buildTypeChip(context, report['type'] as String),
                  const Spacer(),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatRelativeTime(report['date'] as DateTime),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApprovalBadge(BuildContext context, String approvalStatus) {
    Color color;
    IconData icon;
    String label;

    switch (approvalStatus.toUpperCase()) {
      case 'PENDIENTE':
        color = Colors.orange;
        icon = Icons.pending;
        label = 'PENDIENTE';
        break;
      case 'APROBADA':
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'APROBADA';
        break;
      case 'RECHAZADA':
        color = Colors.red;
        icon = Icons.cancel;
        label = 'RECHAZADA';
        break;
      case 'ASIGNADA':
        color = Colors.blue;
        icon = Icons.assignment_turned_in;
        label = 'ASIGNADA';
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
        label = 'N/A';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(BuildContext context, String type) {
    return Chip(
      label: Text(
        type,
        style: const TextStyle(fontSize: 11),
      ),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.grey[100],
    );
  }

  String _formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inHours < 1) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const SizedBox(height: 80),
        Icon(
          Icons.description_outlined,
          size: 80,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 24),
        Text(
          'No has creado reportes',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Usa el botón + para crear tu primer reporte de avance, problema, consulta o incidente de seguridad.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {
            context.push('/project/$projectId/select-incident-type');
          },
          icon: const Icon(Icons.add),
          label: const Text('Crear Primer Reporte'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }
}
