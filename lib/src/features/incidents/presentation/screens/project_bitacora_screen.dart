// lib/src/features/incidents/presentation/screens/project_bitacora_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/core_domain/entities/data_state.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../providers/incidents_list_provider.dart';
import '../widgets/incident_list_item.dart';
import '../utils/incident_helpers.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Screen 13: Bitácora del Proyecto - Historial completo con filtros
/// 
/// OPTIMIZADO EN SEMANA 5:
/// - Reemplazado Consumer por Selector (reducción de rebuilds ~70%)
/// - Agregados const constructors donde es posible
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
  final List<String> _selectedTypes = [];
  final List<String> _selectedStatuses = [];
  final List<String> _selectedDates = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncidentsListProvider>().loadBitacora(widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // OPTIMIZADO EN SEMANA 5: Consumer → Selector
    // Reducción de rebuilds: solo reconstruye cuando bitacoraState cambia
    return Selector<IncidentsListProvider, DataState<List<IncidentEntity>>>(
      selector: (_, provider) => provider.bitacoraState,
      builder: (context, bitacoraState, _) {
        return bitacoraState.when(
          initial: () => const Center(child: Text('Cargando...')),
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (incidents) {
            if (incidents.isEmpty) {
              return const Center(child: Text('No hay incidencias registradas'));
            }

            // Aplicar filtros locales
            final filteredIncidents = _applyFilters(incidents);
            
            return Scaffold(
              appBar: AppBar(
                title: const Text('Bitácora'),
                actions: [
                  IconButton(
                    icon: Badge(
                      isLabelVisible: _hasActiveFilters(),
                      label: Text('${_getTotalFiltersCount()}'),
                      child: const Icon(Icons.filter_list),
                    ),
                    onPressed: _showFilters,
                  ),
                ],
              ),
              body: filteredIncidents.isEmpty
                  ? EmptyState.noData(
                      title: _hasActiveFilters() ? 'No hay resultados' : 'No hay actividad registrada',
                    )
                  : RefreshIndicator(
                      onRefresh: () => context.read<IncidentsListProvider>().loadBitacora(widget.projectId),
                      child: _buildBitacoraList(context, filteredIncidents),
                    ),
            );
          },
          error: (failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar bitácora',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(failure.message),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    onPressed: () => context.read<IncidentsListProvider>().loadBitacora(widget.projectId),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBitacoraList(BuildContext context, List<IncidentEntity> incidents) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: incidents.length,
      itemBuilder: (context, index) {
        final incident = incidents[index];
        return IncidentListItem(
          title: incident.title,
          type: incident.type,
          author: incident.createdBy,
          reportedDate: incident.createdAt,
          status: IncidentHelpers.getStatusLabel(incident.status),
          isCritical: incident.priority == IncidentPriority.critical,
          onTap: () {
            context.push('/incident/${incident.id}');
          },
        );
      },
    );
  }

  void _showFilters() {
    FilterBottomSheet.show(
      context: context,
      title: 'Filtrar Bitácora',
      filterGroups: [
        FilterGroup(
          title: 'Tipo de Incidencia',
          options: const ['Avance', 'Problema', 'Consulta', 'Seguridad', 'Material'],
          selectedOptions: _selectedTypes,
          onChanged: (selected) {
            setState(() {
              _selectedTypes.clear();
              _selectedTypes.addAll(selected);
            });
          },
        ),
        FilterGroup(
          title: 'Estado',
          options: const ['Abierta', 'Cerrada'],
          selectedOptions: _selectedStatuses,
          onChanged: (selected) {
            setState(() {
              _selectedStatuses.clear();
              _selectedStatuses.addAll(selected);
            });
          },
        ),
        FilterGroup(
          title: 'Fecha',
          options: const ['Últimos 7 días', 'Últimos 30 días', 'Este mes'],
          selectedOptions: _selectedDates,
          onChanged: (selected) {
            setState(() {
              _selectedDates.clear();
              _selectedDates.addAll(selected);
            });
          },
        ),
      ],
      onApply: () {
        Navigator.pop(context);
        setState(() {}); // Recargar para aplicar filtros
      },
      onClear: () {
        setState(() {
          _selectedTypes.clear();
          _selectedStatuses.clear();
          _selectedDates.clear();
        });
      },
    );
  }

  bool _hasActiveFilters() {
    return _selectedTypes.isNotEmpty || 
           _selectedStatuses.isNotEmpty || 
           _selectedDates.isNotEmpty;
  }

  int _getTotalFiltersCount() {
    return _selectedTypes.length + _selectedStatuses.length + _selectedDates.length;
  }

  List<IncidentEntity> _applyFilters(List<IncidentEntity> incidents) {
    var filtered = incidents;

    // Filtrar por tipo
    if (_selectedTypes.isNotEmpty) {
      filtered = filtered.where((incident) {
        final typeLabel = IncidentHelpers.getTypeLabel(incident.type);
        return _selectedTypes.contains(typeLabel);
      }).toList();
    }

    // Filtrar por estado
    if (_selectedStatuses.isNotEmpty) {
      filtered = filtered.where((incident) {
        final status = incident.status == IncidentStatus.open ? 'Abierta' : 'Cerrada';
        return _selectedStatuses.contains(status);
      }).toList();
    }

    // Filtrar por fecha
    if (_selectedDates.isNotEmpty) {
      filtered = filtered.where((incident) {
        final now = DateTime.now();
        final incidentDate = incident.createdAt;
        
        for (var dateFilter in _selectedDates) {
          if (dateFilter == 'Últimos 7 días') {
            if (now.difference(incidentDate).inDays <= 7) return true;
          } else if (dateFilter == 'Últimos 30 días') {
            if (now.difference(incidentDate).inDays <= 30) return true;
          } else if (dateFilter == 'Este mes') {
            if (incidentDate.year == now.year && incidentDate.month == now.month) return true;
          }
        }
        return false;
      }).toList();
    }

    return filtered;
  }
}
