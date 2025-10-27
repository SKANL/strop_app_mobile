import '../../../../core/core_domain/entities/incident_entity.dart';
import '../../../../core/core_domain/entities/data_state.dart';
import '../../domain/services/incidents_filter_service.dart';
import 'base_incidents_provider.dart';

/// Provider especializado en gestionar la bitácora de incidentes con filtros.
///
/// Solo maneja:
/// - Cargar bitácora del proyecto
/// - Aplicar filtros de tipo, estado y fecha
/// - Refrescar datos con filtros
class BitacoraProvider extends BaseIncidentsProvider {
  BitacoraProvider({required super.repository});

  // ============================================================================
  // ESTADO - FILTROS
  // ============================================================================
  
  String _selectedType = 'todos';
  String _selectedStatus = 'todos';
  DateTime? _startDate;
  DateTime? _endDate;

  String get selectedType => _selectedType;
  String get selectedStatus => _selectedStatus;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  /// Cargar bitácora del proyecto
  Future<void> loadBitacora(String projectId) async {
    await loadList(
      loadFunction: () async {
        final incidents = await repository.getIncidentsByProject(projectId);
        // Aplicar filtros locales
        return _applyFiltersToList(incidents);
      },
      errorMessage: 'Error al cargar bitácora',
    );
  }

  /// Refrescar bitácora
  Future<void> refreshBitacora(String projectId) async {
    await loadBitacora(projectId);
  }

  // ============================================================================
  // MÉTODOS - Gestión de Filtros
  // ============================================================================

  /// Actualizar filtros de bitácora
  void updateFilters({
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    bool hasChanges = false;

    if (type != null && type != _selectedType) {
      _selectedType = type;
      hasChanges = true;
    }

    if (status != null && status != _selectedStatus) {
      _selectedStatus = status;
      hasChanges = true;
    }

    if (startDate != _startDate) {
      _startDate = startDate;
      hasChanges = true;
    }

    if (endDate != _endDate) {
      _endDate = endDate;
      hasChanges = true;
    }

    if (hasChanges) {
      _reapplyFilters();
    }
  }

  /// Limpiar filtros
  void clearFilters() {
    _selectedType = 'todos';
    _selectedStatus = 'todos';
    _startDate = null;
    _endDate = null;
    
    _reapplyFilters();
  }

  /// Re-aplicar filtros a la data existente sin hacer fetch
  void _reapplyFilters() {
    state.maybeWhen(
      success: (incidents) {
        final filtered = _applyFiltersToList(incidents);
        state = DataState.success(filtered);
      },
      orElse: () {
        // No hay data para filtrar
        notifyListeners();
      },
    );
  }

  /// Aplicar filtros locales a una lista usando IncidentsFilterService
  List<IncidentEntity> _applyFiltersToList(List<IncidentEntity> incidents) {
    // Convertir strings a enums (si no son 'todos')
    IncidentType? typeFilter;
    if (_selectedType != 'todos') {
      try {
        typeFilter = IncidentType.values.firstWhere(
          (t) => t.name == _selectedType,
        );
      } catch (_) {
        typeFilter = null;
      }
    }

    IncidentStatus? statusFilter;
    if (_selectedStatus != 'todos') {
      try {
        statusFilter = IncidentStatus.values.firstWhere(
          (s) => s.name == _selectedStatus,
        );
      } catch (_) {
        statusFilter = null;
      }
    }

    // Aplicar filtros usando el servicio
    var filtered = IncidentsFilterService.filterIncidents(
      incidents,
      type: typeFilter,
      status: statusFilter,
    );

    // Filtrar por rango de fechas
    if (_startDate != null) {
      filtered = filtered.where((i) {
        return i.createdAt.isAfter(_startDate!) || 
               i.createdAt.isAtSameMomentAs(_startDate!);
      }).toList();
    }

    if (_endDate != null) {
      filtered = filtered.where((i) {
        return i.createdAt.isBefore(_endDate!) || 
               i.createdAt.isAtSameMomentAs(_endDate!);
      }).toList();
    }

    return filtered;
  }

  // Override para limpiar también los filtros
  @override
  void clear() {
    super.clear();
    _selectedType = 'todos';
    _selectedStatus = 'todos';
    _startDate = null;
    _endDate = null;
  }
}