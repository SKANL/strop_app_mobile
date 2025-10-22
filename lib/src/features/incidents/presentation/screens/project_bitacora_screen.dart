// lib/src/features/incidents/presentation/screens/project_bitacora_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../providers/incidents_provider.dart';
import '../widgets/incident_list_item.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Screen 13: Bitácora del Proyecto - Historial completo con filtros
class ProjectBitacoraScreen extends StatefulWidget {
  final String projectId;

  const ProjectBitacoraScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectBitacoraScreen> createState() => _ProjectBitacoraScreenState();
}

class _ProjectBitacoraScreenState extends State<ProjectBitacoraScreen> {
  String? _selectedType;
  String? _selectedStatus;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncidentsProvider>().loadBitacora(widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IncidentsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingBitacora) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.bitacoraError != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar bitácora',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(provider.bitacoraError!),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => provider.loadBitacora(widget.projectId),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final incidents = provider.bitacora;

        return ResponsiveLayout(
          mobileBody: Column(
            children: [
              // Barra de filtros
              _buildFiltersBar(context),

              // Lista de incidencias
              Expanded(
                child: incidents.isEmpty
                    ? EmptyState.noData(title: _hasActiveFilters() ? 'No hay resultados' : 'No hay actividad registrada')
                    : RefreshIndicator(
                        onRefresh: () => provider.loadBitacora(widget.projectId),
                        child: _buildIncidentsList(context, incidents),
                      ),
              ),
            ],
          ),
          tabletBody: Row(
            children: [
              SizedBox(width: 300, child: _buildFiltersPanel()),
              Expanded(
                child: incidents.isEmpty
                    ? EmptyState.noData(title: _hasActiveFilters() ? 'No hay resultados' : 'No hay actividad registrada')
                    : RefreshIndicator(
                        onRefresh: () => provider.loadBitacora(widget.projectId),
                        child: _buildIncidentsList(context, incidents),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFiltersBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterChip(
              icon: Icons.filter_list,
              label: _selectedType ?? 'Tipo',
              onTap: () => _showTypeFilter(context),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterChip(
              icon: Icons.circle,
              iconSize: 10,
              label: _selectedStatus ?? 'Estado',
              onTap: () => _showStatusFilter(context),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterChip(
              icon: Icons.calendar_today,
              label: _selectedDateRange == null ? 'Fecha' : 'Rango',
              onTap: () => _showDateFilter(context),
            ),
          ),
          
          // Botón para limpiar filtros
          if (_hasActiveFilters()) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.clear_all, size: 20),
              onPressed: _clearFilters,
              tooltip: 'Limpiar filtros',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    double? iconSize,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(0, 36),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize ?? 16),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedType != null || 
           _selectedStatus != null || 
           _selectedDateRange != null;
  }

  void _clearFilters() {
    setState(() {
      _selectedType = null;
      _selectedStatus = null;
      _selectedDateRange = null;
    });
    final provider = context.read<IncidentsProvider>();
    provider.clearFilters();
    provider.loadBitacora(widget.projectId);
  }

  void _showTypeFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _FilterBottomSheet(
        title: 'Filtrar por Tipo',
        options: [
          'Todos',
          'Avance',
          'Problema',
          'Consulta',
          'Seguridad',
          'Material',
        ],
        selectedValue: _selectedType,
        onSelected: (value) {
          setState(() {
            _selectedType = value == 'Todos' ? null : value;
          });
          // Cerrar el sheet usando el contexto del builder y usar el contexto
          // externo para acceder al Provider (evita ProviderNotFoundException)
          Navigator.pop(ctx);
          context.read<IncidentsProvider>().updateFilters(type: _selectedType?.toLowerCase());
        },
      ),
    );
  }

  void _showStatusFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _FilterBottomSheet(
        title: 'Filtrar por Estado',
        options: [
          'Todos',
          'Abierta',
          'Cerrada',
          'Pendiente',
        ],
        selectedValue: _selectedStatus,
        onSelected: (value) {
          setState(() {
            _selectedStatus = value == 'Todos' ? null : value;
          });
          Navigator.pop(ctx);
          context.read<IncidentsProvider>().updateFilters(status: _selectedStatus?.toLowerCase());
        },
      ),
    );
  }

  void _showDateFilter(BuildContext context) async {
    final provider = context.read<IncidentsProvider>();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      if (!mounted) return;
      setState(() {
        _selectedDateRange = picked;
      });
      provider.updateFilters(startDate: picked.start, endDate: picked.end);
    }
  }

  Widget _buildIncidentsList(BuildContext context, List incidents) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: incidents.length,
      itemBuilder: (context, index) {
        final incident = incidents[index];
        return IncidentListItem(
          title: incident.title,
          type: _getTypeLabel(incident.type),
          author: incident.createdBy,
          reportedDate: incident.createdAt,
          status: _getStatusLabel(incident.status),
          isCritical: incident.priority == IncidentPriority.critical,
          onTap: () {
            context.push('/incident/${incident.id}');
          },
        );
      },
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

  String _getStatusLabel(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.open:
        return 'Abierta';
      case IncidentStatus.closed:
        return 'Cerrada';
    }
  }

  // Empty state handled by EmptyState widgets in the layouts above.

  Widget _buildFiltersPanel() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Filtros', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildFilterChip(icon: Icons.filter_list, label: _selectedType ?? 'Tipo', onTap: () => _showTypeFilter(context)),
        const SizedBox(height: 8),
        _buildFilterChip(icon: Icons.circle, label: _selectedStatus ?? 'Estado', onTap: () => _showStatusFilter(context)),
        const SizedBox(height: 8),
        _buildFilterChip(icon: Icons.calendar_today, label: _selectedDateRange == null ? 'Fecha' : 'Rango', onTap: () => _showDateFilter(context)),
      ],
    );
  }
}

/// Widget auxiliar para el bottom sheet de filtros
class _FilterBottomSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  const _FilterBottomSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...options.map((option) => ListTile(
                title: Text(option),
                trailing: selectedValue == option || (option == 'Todos' && selectedValue == null)
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () => onSelected(option),
              )),
        ],
      ),
    );
  }
}
