// lib/src/features/incidents/presentation/screens/lists/my_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/data_state.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/incident_entity.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../../providers/incidents_list_provider.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';
import '../../helpers/incident_helpers.dart';
import '../../widgets/list_items/incident_list_item.dart';

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
        return IncidentListItem(
          title: report.title,
          type: report.type,
          author: report.createdBy,
          reportedDate: report.createdAt,
          status: IncidentHelpers.getStatusLabel(report.status),
          isCritical: report.priority == IncidentPriority.critical,
          approvalStatus: report.approvalStatus,
          showRelativeTime: true,
          onTap: () {
            context.push('/incident/${report.id}');
          },
        );
      },
    );
  }

  // Empty state handled via EmptyState.noReports() in build()
}
