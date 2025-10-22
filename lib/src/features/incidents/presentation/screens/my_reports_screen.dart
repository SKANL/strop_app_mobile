// lib/src/features/incidents/presentation/screens/my_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../providers/incidents_provider.dart';

/// Screen 12: Mis Reportes - Lista de incidencias creadas por el usuario (Bottom-Up)
class MyReportsScreen extends StatefulWidget {
  final String projectId;

  const MyReportsScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncidentsProvider>().loadMyReports('user-cabo-001');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IncidentsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingReports) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.reportsError != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar reportes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(provider.reportsError!),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => provider.loadMyReports('user-cabo-001'),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final reports = provider.myReports;

        if (reports.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadMyReports('user-cabo-001'),
          child: _buildReportsList(context, reports),
        );
      },
    );
  }

  Widget _buildReportsList(BuildContext context, List<IncidentEntity> reports) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return _buildReportCard(context, report);
      },
    );
  }

  Widget _buildReportCard(BuildContext context, IncidentEntity report) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          context.push('/incident/${report.id}');
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
                      report.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildApprovalBadge(context, report.approvalStatus),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Tipo y fecha
              Row(
                children: [
                  _buildTypeChip(context, _getTypeLabel(report.type)),
                  const Spacer(),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatRelativeTime(report.createdAt),
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

  Widget _buildApprovalBadge(BuildContext context, ApprovalStatus? approvalStatus) {
    if (approvalStatus == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.help_outline, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              'N/A',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    Color color;
    IconData icon;
    String label;

    switch (approvalStatus) {
      case ApprovalStatus.pending:
        color = Colors.orange;
        icon = Icons.pending;
        label = 'PENDIENTE';
        break;
      case ApprovalStatus.approved:
        color = Colors.green;
        icon = Icons.check_circle;
        label = 'APROBADA';
        break;
      case ApprovalStatus.rejected:
        color = Colors.red;
        icon = Icons.cancel;
        label = 'RECHAZADA';
        break;
      case ApprovalStatus.assigned:
        color = Colors.blue;
        icon = Icons.assignment_turned_in;
        label = 'ASIGNADA';
        break;
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

  String _getTypeLabel(IncidentType type) {
    switch (type) {
      case IncidentType.progressReport:
        return 'Avance';
      case IncidentType.problem:
        return 'Problema';
      case IncidentType.consultation:
        return 'Consulta';
      case IncidentType.safetyIncident:
        return 'Seguridad';
      case IncidentType.materialRequest:
        return 'Material';
    }
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
            context.push('/project/${widget.projectId}/select-incident-type');
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
