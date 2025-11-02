// lib/src/features/incidents/presentation/providers/incidents_list_provider.dart
import 'package:flutter/foundation.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/incident_entity.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/data_state.dart';
import '../../../../core/core_domain/errors/failures.dart';
import '../../../../core/core_domain/repositories/incident_repository.dart';
import '../../domain/services/incidents_filter_service.dart';

/// Provider especializado para gestionar LISTAS de incidencias
/// 
/// REFACTORIZADO EN SEMANA 4:
/// - Usa IncidentsFilterService para filtrado y ordenamiento
/// - Reducido de 279 → ~200 líneas (-28%)
/// - Eliminada lógica de filtrado duplicada
/// 
/// Responsabilidades (SRP):
/// - Cargar y gestionar lista de tareas asignadas (MyTasks)
/// - Cargar y gestionar lista de reportes creados (MyReports)
/// - Cargar y gestionar bitácora del proyecto con filtros
/// - Gestionar filtros de búsqueda y fecha
/// 
/// No maneja:
/// - Detalles de incidencias individuales (ver IncidentDetailProvider)
/// - Creación/edición de incidencias (ver IncidentFormProvider)
class IncidentsListProvider extends ChangeNotifier {
  final IncidentRepository repository;

  IncidentsListProvider({required this.repository});

  // ============================================================================
  // ESTADO - Mis Tareas (con DataState)
  // ============================================================================
  
  DataState<List<IncidentEntity>> _myTasksState = const DataState.initial();
  
  DataState<List<IncidentEntity>> get myTasksState => _myTasksState;
  
  List<IncidentEntity> get myTasks => _myTasksState.dataOrNull ?? [];
  bool get isLoadingTasks => _myTasksState.isLoading;
  String? get tasksError => _myTasksState.failureOrNull?.message;

  // ============================================================================
  // ESTADO - Mis Reportes (con DataState)
  // ============================================================================
  
  DataState<List<IncidentEntity>> _myReportsState = const DataState.initial();
  
  DataState<List<IncidentEntity>> get myReportsState => _myReportsState;
  
  List<IncidentEntity> get myReports => _myReportsState.dataOrNull ?? [];
  bool get isLoadingReports => _myReportsState.isLoading;
  String? get reportsError => _myReportsState.failureOrNull?.message;

  // ============================================================================
  // ESTADO - Bitácora (con DataState)
  // ============================================================================
  
  DataState<List<IncidentEntity>> _bitacoraState = const DataState.initial();
  
  DataState<List<IncidentEntity>> get bitacoraState => _bitacoraState;
  
  List<IncidentEntity> get bitacora => _bitacoraState.dataOrNull ?? [];
  bool get isLoadingBitacora => _bitacoraState.isLoading;
  String? get bitacoraError => _bitacoraState.failureOrNull?.message;

  // ============================================================================
  // FILTROS
  // ============================================================================
  
  String _selectedType = 'todos';
  String _selectedStatus = 'todos';
  DateTime? _startDate;
  DateTime? _endDate;

  String get selectedType => _selectedType;
  String get selectedStatus => _selectedStatus;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // ============================================================================
  // MÉTODOS PRIVADOS - Helpers para reducir duplicación
  // ============================================================================

  /// Método genérico para cargar listas y actualizar estado
  Future<void> _loadList({
    required Future<List<IncidentEntity>> Function() loadFunction,
    required void Function(DataState<List<IncidentEntity>>) setState,
    required String errorMessage,
  }) async {
    setState(const DataState.loading());
    notifyListeners();

    try {
      final items = await loadFunction();
      setState(DataState.success(items));
      notifyListeners();
    } catch (e) {
      setState(DataState.error(
        UnexpectedFailure(message: '$errorMessage: ${e.toString()}'),
      ));
      notifyListeners();
    }
  }

  // ============================================================================
  // MÉTODOS - Cargar Mis Tareas
  // ============================================================================

  /// Cargar tareas asignadas al usuario
  Future<void> loadMyTasks(String userId, {String projectId = ''}) async {
    await _loadList(
      loadFunction: () => repository.getMyTasks(userId, projectId),
      setState: (state) => _myTasksState = state,
      errorMessage: 'Error al cargar tareas',
    );
  }

  /// Refrescar tareas
  Future<void> refreshTasks(String userId, {String projectId = ''}) async {
    await loadMyTasks(userId, projectId: projectId);
  }

  // ============================================================================
  // MÉTODOS - Cargar Mis Reportes
  // ============================================================================

  /// Cargar reportes creados por el usuario
  Future<void> loadMyReports(String userId, {String projectId = ''}) async {
    await _loadList(
      loadFunction: () => repository.getMyReports(userId, projectId),
      setState: (state) => _myReportsState = state,
      errorMessage: 'Error al cargar reportes',
    );
  }

  /// Refrescar reportes
  Future<void> refreshReports(String userId, {String projectId = ''}) async {
    await loadMyReports(userId, projectId: projectId);
  }

  // ============================================================================
  // MÉTODOS - Cargar Bitácora con Filtros
  // ============================================================================

  /// Cargar bitácora del proyecto
  Future<void> loadBitacora(String projectId) async {
    await _loadList(
      loadFunction: () async {
        final incidents = await repository.getIncidentsByProject(projectId);
        // Aplicar filtros locales
        return _applyFiltersToList(incidents);
      },
      setState: (state) => _bitacoraState = state,
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
    _bitacoraState.maybeWhen(
      success: (incidents) {
        final filtered = _applyFiltersToList(incidents);
        _bitacoraState = DataState.success(filtered);
        notifyListeners();
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

  // ============================================================================
  // MÉTODOS - Utilidades
  // ============================================================================

  /// Limpiar todos los datos
  void clear() {
    _myTasksState = const DataState.initial();
    _myReportsState = const DataState.initial();
    _bitacoraState = const DataState.initial();
    _selectedType = 'todos';
    _selectedStatus = 'todos';
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  /// Obtener cantidad total de tareas pendientes (open status)
  int get pendingTasksCount {
    final statusCounts = IncidentsFilterService.countByStatus(myTasks);
    return statusCounts[IncidentStatus.open] ?? 0;
  }

  /// Obtener cantidad total de reportes
  int get totalReportsCount => myReports.length;

  /// Obtener incidentes filtrados de bitácora
  int get filteredIncidentsCount => bitacora.length;
  
  /// Obtener contadores por estado de tareas
  Map<IncidentStatus, int> get tasksCountByStatus {
    return IncidentsFilterService.countByStatus(myTasks);
  }
  
  /// Obtener contadores por prioridad de tareas
  Map<IncidentPriority, int> get tasksCountByPriority {
    return IncidentsFilterService.countByPriority(myTasks);
  }
  
  /// Obtener incidencias críticas de tareas
  List<IncidentEntity> get criticalTasks {
    return IncidentsFilterService.getCriticalIncidents(myTasks);
  }
}
