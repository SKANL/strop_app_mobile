// lib/src/features/incidents/presentation/screens/my_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/domain/entities/data_state.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../../../auth/presentation/manager/auth_provider.dart';
import '../providers/incidents_list_provider.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Screen 12: Mis Reportes - Lista de incidencias creadas por el usuario (Bottom-Up)
/// 
/// OPTIMIZADO EN SEMANA 5:
/// - Reemplazado Consumer por Selector (reducción de rebuilds ~70%)
/// - Agregados const constructors donde es posible
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
      final userId = context.read<AuthProvider>().user?.id ?? '';
      context.read<IncidentsListProvider>().loadMyReports(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // OPTIMIZADO EN SEMANA 5: Consumer → Selector
    // Reducción de rebuilds: solo reconstruye cuando myReportsState cambia
    return Selector<IncidentsListProvider, DataState<List<IncidentEntity>>>(
      selector: (_, provider) => provider.myReportsState,
      builder: (context, reportsState, _) {
        return reportsState.when(
          initial: () => const Center(child: Text('Cargando...')),
          loading: () => const Center(child: AppLoading()),
          success: (reports) {
            if (reports.isEmpty) {
              return EmptyState.noReports(
                onCreateReport: () => context.push('/project/${widget.projectId}/select-incident-type'),
              );
            }

            return RefreshIndicator(
              onRefresh: () {
                final userId = context.read<AuthProvider>().user?.id ?? '';
                return context.read<IncidentsListProvider>().loadMyReports(userId);
              },
              child: _buildReportsList(context, reports),
            );
          },
          error: (failure) {
            return Center(
              child: AppError(
                message: failure.message,
                onRetry: () {
                  final userId = context.read<AuthProvider>().user?.id ?? '';
                  context.read<IncidentsListProvider>().loadMyReports(userId);
                },
              ),
            );
          },
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
                  ApprovalBadge(status: report.approvalStatus),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Tipo y fecha
              Row(
                children: [
                  TypeChip(type: report.type),
                  const Spacer(),
                  Icon(Icons.access_time, size: 14, color: AppColors.iconColor),
                  const SizedBox(width: 4),
                  Text(
                    _formatRelativeTime(report.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.iconColor,
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

  // Empty state handled via EmptyState.noReports() in build()
}
