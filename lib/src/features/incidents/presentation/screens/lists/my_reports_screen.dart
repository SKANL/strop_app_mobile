// lib/src/features/incidents/presentation/screens/lists/my_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/data_state.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/incident_entity.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../../providers/incidents_list_provider.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';
import '../../utils/converters/incident_converters.dart';
import '../../widgets/list_items/incident_list_item.dart';

import 'package:mobile_strop_app/src/core/core_ui/theme/app_colors.dart';

/// Screen 12: Mis Reportes - Lista de incidencias creadas por el usuario (Bottom-Up)
///
/// OPTIMIZADO EN SEMANA 5:
/// - Reemplazado Consumer por Selector (reducción de rebuilds ~70%)
/// - Agregados const constructors donde es posible
class MyReportsScreen extends StatefulWidget {
  final String projectId;

  const MyReportsScreen({super.key, required this.projectId});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

enum ReportFilter { all, open, closed, critical }

class _MyReportsScreenState extends State<MyReportsScreen> {
  ReportFilter _selectedFilter = ReportFilter.all;

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
    return Selector<IncidentsListProvider, DataState<List<IncidentEntity>>>(
      selector: (_, provider) => provider.myReportsState,
      builder: (context, reportsState, _) {
        return reportsState.when(
          initial: () => const Center(child: Text('Cargando...')),
          loading: () => const Center(child: AppLoading()),
          success: (reports) {
            // Calculate stats
            final total = reports.length;
            final open = reports
                .where((r) => r.status == IncidentStatus.open)
                .length;
            final closed = reports
                .where((r) => r.status == IncidentStatus.closed)
                .length;

            // Filter reports
            final filteredReports = _filterReports(reports);

            return RefreshIndicator(
              onRefresh: () {
                final userId = context.read<AuthProvider>().user?.id ?? '';
                return context.read<IncidentsListProvider>().loadMyReports(
                  userId,
                );
              },
              child: Column(
                children: [
                  // Summary Cards
                  _buildSummaryCards(total, open, closed),

                  // Filters
                  _buildFilterChips(),

                  const SizedBox(height: 8),

                  // List or Empty State
                  Expanded(
                    child: filteredReports.isEmpty
                        ? (reports.isEmpty
                              ? EmptyState.noReports(
                                  onCreateReport: null,
                                ) // Button removed
                              : EmptyState.noResults(
                                  query: 'Filtro seleccionado',
                                ))
                        : _buildReportsList(context, filteredReports),
                  ),
                ],
              ),
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

  List<IncidentEntity> _filterReports(List<IncidentEntity> reports) {
    switch (_selectedFilter) {
      case ReportFilter.all:
        return reports;
      case ReportFilter.open:
        return reports.where((r) => r.status == IncidentStatus.open).toList();
      case ReportFilter.closed:
        return reports.where((r) => r.status == IncidentStatus.closed).toList();
      case ReportFilter.critical:
        return reports
            .where((r) => r.priority == IncidentPriority.critical)
            .toList();
    }
  }

  Widget _buildSummaryCards(int total, int open, int closed) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildStatCard('Total', total.toString(), AppColors.primary),
          const SizedBox(width: 12),
          _buildStatCard('Abiertos', open.toString(), AppColors.warning),
          const SizedBox(width: 12),
          _buildStatCard('Cerrados', closed.toString(), AppColors.success),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildFilterChip('Todos', ReportFilter.all),
          const SizedBox(width: 8),
          _buildFilterChip('Abiertos', ReportFilter.open),
          const SizedBox(width: 8),
          _buildFilterChip('Cerrados', ReportFilter.closed),
          const SizedBox(width: 8),
          _buildFilterChip('Críticos', ReportFilter.critical),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, ReportFilter filter) {
    final isSelected = _selectedFilter == filter;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = filter;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary.withOpacity(0.1),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.borderColor,
        ),
      ),
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
          status: IncidentConverters.getStatusLabel(report.status),
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
}
