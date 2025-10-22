// lib/src/features/incidents/presentation/providers/incidents_provider.dart
import 'package:flutter/foundation.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../../../../core/core_domain/repositories/incident_repository.dart';

/// Provider para gestionar el estado de incidencias
/// 
/// Responsabilidades:
/// - Cargar tareas asignadas (MyTasks)
/// - Cargar reportes creados (MyReports)
/// - Cargar bitácora del proyecto con filtros
/// - CRUD de incidencias
/// - Gestionar estados de loading y error
class IncidentsProvider extends ChangeNotifier {
  final IncidentRepository repository;

  IncidentsProvider({required this.repository});

  // Estado de Mis Tareas (asignadas al usuario)
  List<IncidentEntity> _myTasks = [];
  bool _isLoadingTasks = false;
  String? _tasksError;

  // Estado de Mis Reportes (creadas por el usuario)
  List<IncidentEntity> _myReports = [];
  bool _isLoadingReports = false;
  String? _reportsError;

  // Estado de Bitácora del proyecto (con filtros)
  List<IncidentEntity> _bitacora = [];
  bool _isLoadingBitacora = false;
  String? _bitacoraError;

  // Filtros de bitácora
  String _selectedType = 'todos';
  String _selectedStatus = 'todos';
  DateTime? _startDate;
  DateTime? _endDate;

  // Incidencia seleccionada para detalle
  IncidentEntity? _selectedIncident;
  bool _isLoadingDetail = false;
  String? _detailError;

  // Estado de operaciones (crear, asignar, cerrar)
  bool _isCreating = false;
  bool _isUpdating = false;
  String? _operationError;

  // Getters públicos
  List<IncidentEntity> get myTasks => _myTasks;
  bool get isLoadingTasks => _isLoadingTasks;
  String? get tasksError => _tasksError;

  List<IncidentEntity> get myReports => _myReports;
  bool get isLoadingReports => _isLoadingReports;
  String? get reportsError => _reportsError;

  List<IncidentEntity> get bitacora => _bitacora;
  bool get isLoadingBitacora => _isLoadingBitacora;
  String? get bitacoraError => _bitacoraError;

  String get selectedType => _selectedType;
  String get selectedStatus => _selectedStatus;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  IncidentEntity? get selectedIncident => _selectedIncident;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  String? get operationError => _operationError;

  /// Cargar Mis Tareas (asignadas al usuario)
  Future<void> loadMyTasks(String userId, {String projectId = ''}) async {
    _isLoadingTasks = true;
    _tasksError = null;
    notifyListeners();

    try {
      _myTasks = await repository.getMyTasks(userId, projectId);
      _isLoadingTasks = false;
      notifyListeners();
    } catch (e) {
      _tasksError = e.toString();
      _isLoadingTasks = false;
      notifyListeners();
    }
  }

  /// Cargar Mis Reportes (creados por el usuario)
  Future<void> loadMyReports(String userId, {String projectId = ''}) async {
    _isLoadingReports = true;
    _reportsError = null;
    notifyListeners();

    try {
      _myReports = await repository.getMyReports(userId, projectId);
      _isLoadingReports = false;
      notifyListeners();
    } catch (e) {
      _reportsError = e.toString();
      _isLoadingReports = false;
      notifyListeners();
    }
  }

  /// Cargar Bitácora del proyecto con filtros
  Future<void> loadBitacora(String projectId) async {
    _isLoadingBitacora = true;
    _bitacoraError = null;
    notifyListeners();

    try {
      _bitacora = await repository.getIncidentsByProject(projectId);
      
      // Aplicar filtros locales
      _applyFilters();
      
      _isLoadingBitacora = false;
      notifyListeners();
    } catch (e) {
      _bitacoraError = e.toString();
      _isLoadingBitacora = false;
      notifyListeners();
    }
  }

  /// Cargar detalle de incidencia
  Future<void> loadIncidentDetail(String incidentId) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();

    try {
      _selectedIncident = await repository.getIncidentById(incidentId);
      _isLoadingDetail = false;
      notifyListeners();
    } catch (e) {
      _detailError = e.toString();
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  /// Crear nueva incidencia
  Future<bool> createIncident(IncidentEntity incident) async {
    _isCreating = true;
    _operationError = null;
    notifyListeners();

    try {
      await repository.createIncident(incident);
      _isCreating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _operationError = e.toString();
      _isCreating = false;
      notifyListeners();
      return false;
    }
  }

  /// Asignar incidencia a usuario
  Future<bool> assignIncident(String incidentId, String userId) async {
    _isUpdating = true;
    _operationError = null;
    notifyListeners();

    try {
      final updated = await repository.assignIncident(incidentId, userId);
      if (_selectedIncident?.id == incidentId) {
        _selectedIncident = updated;
      }
      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _operationError = e.toString();
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  /// Cerrar incidencia
  Future<bool> closeIncident(String incidentId, String closeNote) async {
    _isUpdating = true;
    _operationError = null;
    notifyListeners();

    try {
      final updated = await repository.closeIncident(incidentId, closeNote);
      if (_selectedIncident?.id == incidentId) {
        _selectedIncident = updated;
      }
      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _operationError = e.toString();
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  /// Agregar comentario
  Future<bool> addComment(String incidentId, String comment) async {
    _isUpdating = true;
    _operationError = null;
    notifyListeners();

    try {
      await repository.addComment(incidentId, comment);
      // Recargar detalle para mostrar el comentario
      await loadIncidentDetail(incidentId);
      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _operationError = e.toString();
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  /// Agregar aclaración/corrección
  Future<bool> addCorrection(String incidentId, String correction) async {
    _isUpdating = true;
    _operationError = null;
    notifyListeners();

    try {
      await repository.addCorrection(incidentId, correction);
      // Recargar detalle para mostrar la aclaración
      await loadIncidentDetail(incidentId);
      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _operationError = e.toString();
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  /// Actualizar filtros de bitácora
  void updateFilters({
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (type != null) _selectedType = type;
    if (status != null) _selectedStatus = status;
    _startDate = startDate;
    _endDate = endDate;
    
    _applyFilters();
    notifyListeners();
  }

  /// Limpiar filtros
  void clearFilters() {
    _selectedType = 'todos';
    _selectedStatus = 'todos';
    _startDate = null;
    _endDate = null;
    
    _applyFilters();
    notifyListeners();
  }

  /// Aplicar filtros locales a la bitácora
  void _applyFilters() {
    // TODO: Implementar filtrado local si es necesario
    // Por ahora el FakeDataSource ya filtra en el backend
  }

  /// Seleccionar incidencia de la lista
  void selectIncident(IncidentEntity incident) {
    _selectedIncident = incident;
    notifyListeners();
  }

  /// Limpiar incidencia seleccionada
  void clearSelectedIncident() {
    _selectedIncident = null;
    _detailError = null;
    notifyListeners();
  }

  /// Refrescar tareas
  Future<void> refreshTasks(String userId, {String projectId = ''}) async {
    await loadMyTasks(userId, projectId: projectId);
  }

  /// Refrescar reportes
  Future<void> refreshReports(String userId, {String projectId = ''}) async {
    await loadMyReports(userId, projectId: projectId);
  }

  /// Refrescar bitácora
  Future<void> refreshBitacora(String projectId) async {
    await loadBitacora(projectId);
  }

  /// Limpiar todos los datos
  void clear() {
    _myTasks = [];
    _myReports = [];
    _bitacora = [];
    _selectedIncident = null;
    _tasksError = null;
    _reportsError = null;
    _bitacoraError = null;
    _detailError = null;
    _operationError = null;
    _selectedType = 'todos';
    _selectedStatus = 'todos';
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }
}
