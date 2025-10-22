// lib/src/features/incidents/presentation/screens/project_bitacora_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../providers/incidents_provider.dart';
import '../widgets/incident_list_item.dart';

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

        return Column(
          children: [
            // Barra de filtros
            _buildFiltersBar(context),
            
            // Lista de incidencias
            Expanded(
              child: incidents.isEmpty
                  ? _buildEmptyState(context)
                  : RefreshIndicator(
                      onRefresh: () => provider.loadBitacora(widget.projectId),
                      child: _buildIncidentsList(context, incidents),
                    ),
            ),
          ],
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
    // TODO: Recargar lista sin filtros
  }

  void _showTypeFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _FilterBottomSheet(
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
          Navigator.pop(context);
          // TODO: Aplicar filtro
        },
      ),
    );
  }

  void _showStatusFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _FilterBottomSheet(
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
          Navigator.pop(context);
          // TODO: Aplicar filtro
        },
      ),
    );
  }

  void _showDateFilter(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      // TODO: Aplicar filtro
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              _hasActiveFilters() 
                  ? 'No hay resultados para los filtros seleccionados'
                  : 'No hay actividad registrada',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _hasActiveFilters()
                  ? 'Intenta cambiar los filtros para ver más resultados.'
                  : 'La bitácora mostrará toda la actividad del proyecto una vez que se creen reportes.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
            if (_hasActiveFilters()) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Limpiar Filtros'),
              ),
            ],
          ],
        ),
      ),
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
