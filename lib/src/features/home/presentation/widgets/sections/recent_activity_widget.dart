// lib/src/features/home/presentation/widgets/sections/recent_activity_widget.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/core_ui/theme/app_colors.dart';
import '../../../../../core/core_domain/entities/incident_entity.dart';
import '../../../../incidents/presentation/utils/converters/incident_converters.dart';
import '../../../../incidents/presentation/providers/my_reports_provider.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';

/// Widget que muestra la actividad reciente del usuario
/// 
/// Muestra las últimas 5 incidencias creadas por el usuario
/// usando MyReportsProvider con datos REALES
class RecentActivityWidget extends StatefulWidget {
  const RecentActivityWidget({super.key});

  @override
  State<RecentActivityWidget> createState() => _RecentActivityWidgetState();
}

class _RecentActivityWidgetState extends State<RecentActivityWidget> {
  @override
  void initState() {
    super.initState();
    // Defer loading reports until after first frame to avoid rebuild issues
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRecentReports());
  }

  void _loadRecentReports() {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.id ?? '';
    
    if (userId.isNotEmpty) {
      // Cargar reportes del usuario (sin filtro de proyecto para ver todos)
      context.read<MyReportsProvider>().loadMyReports(userId, projectId: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mis Reportes Recientes',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              
              Consumer<MyReportsProvider>(
                builder: (context, reportsProvider, _) {
                  final reports = reportsProvider.items;
                  if (reports.isNotEmpty) {
                    return TextButton(
                      onPressed: () {
                        // TODO: Crear vista completa de todos los reportes
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vista completa próximamente'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Text('Ver todo'),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Consumer<MyReportsProvider>(
            builder: (context, reportsProvider, _) {
              // Loading state
              if (reportsProvider.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final recentIncidents = reportsProvider.items;

              // Empty state
              if (recentIncidents.isEmpty) {
                return _buildEmptyState(context);
              }

              // Mostrar últimos 5 reportes
              return Column(
                children: recentIncidents
                    .take(5)
                    .map((incident) => _buildActivityItem(context, incident))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: AppColors.iconColor,
          ),
          const SizedBox(height: 12),
          Text(
            'No hay actividad reciente',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.iconColor,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Crea tu primer reporte para comenzar',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.iconColor,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, IncidentEntity incident) {
    final typeColor = _getTypeColor(incident.type);
    final statusLabel = IncidentConverters.getStatusLabel(incident.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => context.push('/incident/${incident.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              // Indicador de tipo
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: typeColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      incident.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Meta información
                    Row(
                      children: [
                        Icon(
                          _getTypeIcon(incident.type),
                          size: 14,
                          color: typeColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          IncidentConverters.getTypeLabel(incident.type),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: typeColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(color: AppColors.iconColor),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(incident.createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.iconColor,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Estado
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.withOpacity(_getStatusColor(incident.status), 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(incident.status),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(IncidentType type) {
    switch (type) {
      case IncidentType.progressReport:
        return AppColors.progressReportColor;
      case IncidentType.problem:
        return AppColors.problemColor;
      case IncidentType.consultation:
        return AppColors.consultationColor;
      case IncidentType.safetyIncident:
        return AppColors.safetyIncidentColor;
      case IncidentType.materialRequest:
        return AppColors.materialRequestColor;
    }
  }

  IconData _getTypeIcon(IncidentType type) {
    switch (type) {
      case IncidentType.progressReport:
        return Icons.trending_up;
      case IncidentType.problem:
        return Icons.error_outline;
      case IncidentType.consultation:
        return Icons.help_outline;
      case IncidentType.safetyIncident:
        return Icons.shield_outlined;
      case IncidentType.materialRequest:
        return Icons.inventory_2_outlined;
    }
  }

  Color _getStatusColor(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.open:
        return Colors.orange;
      case IncidentStatus.closed:
        return Colors.green;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Hace ${difference.inMinutes}m';
      }
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
