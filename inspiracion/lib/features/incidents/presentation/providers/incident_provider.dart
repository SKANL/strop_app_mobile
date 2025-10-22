import 'package:flutter/foundation.dart';
import '../../../../core/sync/sync_service.dart';
import '../../../../domain/entities/incident_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/usecases/close_incident.dart';
import '../../../../domain/usecases/get_incidents_for_project.dart';
import '../../../../domain/usecases/create_incident.dart';
import '../../../../domain/usecases/get_incident_by_id.dart';
import '../../../../domain/usecases/assign_incident.dart';

class IncidentProvider extends ChangeNotifier {
  final GetIncidentsForProject _getIncidents;
  final CreateIncident _createIncident;
  final GetIncidentById _getIncidentById;
  final AssignIncident _assignIncident;
  final CloseIncident _closeIncident;
  final SyncService? _syncService;

  String? _currentProjectId; // Para saber qué proyecto refrescar

  IncidentProvider(
    this._getIncidents,
    this._createIncident,
    this._getIncidentById,
    this._assignIncident,
    this._closeIncident, {
    SyncService? syncService,
  }) : _syncService = syncService {
    // Escuchar cambios en SyncService para auto-refrescar
    _syncService?.addListener(_onSyncCompleted);
  }

  /// Callback que se ejecuta cuando SyncService completa una sincronización
  void _onSyncCompleted() {
    final syncResult = _syncService?.lastSyncResult;
    
    // Solo refrescar si hubo sincronización exitosa de incidentes
    if (syncResult != null && 
        syncResult.syncedItems > 0 && 
        !_isLoading &&
        _currentProjectId != null) {
      
      // Verificar si se sincronizaron incidentes
      final syncedIncidents = _syncService?.pendingItems
          .where((item) => item.type == 'incident')
          .length ?? 0;
      
      if (syncedIncidents > 0 || syncResult.syncedItems > 0) {
        // Auto-refrescar datos del proyecto actual
        _silentRefresh(_currentProjectId!);
      }
    }
  }

  /// Refresca datos sin mostrar spinner de carga (para sincronización en background)
  Future<void> _silentRefresh(String projectId) async {
    try {
      final updatedIncidents = await _getIncidents.call(projectId);
      _incidents = updatedIncidents;
      notifyListeners(); // Actualiza UI automáticamente
    } catch (e) {
      // Error silencioso, no afecta la UX
      debugPrint('🔄 Error en refresh silencioso de incidents: $e');
    }
  }

  bool _isLoading = false;
  bool _isCreating = false;
  bool _isDetailLoading = false;
  bool _isAssigning = false;
  bool _isClosing = false;
  List<Incident> _incidents = [];
  Incident? _selectedIncident;
  String? _error;
  Incident? _selectedIncidentForDetail;
  Incident? get selectedIncidentForDetail => _selectedIncidentForDetail;

  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isDetailLoading => _isDetailLoading;
  bool get isAssigning => _isAssigning;
  bool get isClosing => _isClosing;
  List<Incident> get incidents => _incidents;
  Incident? get selectedIncident => _selectedIncident;
  String? get error => _error;

  Future<bool> assignIncident({
    required String incidentId,
    required User userToAssign,
  }) async {
    _isAssigning = true;
    _error = null; // <-- De la opción 1: Limpia el error
    notifyListeners();

    try {
      final updated = await _assignIncident.call(
        incidentId: incidentId,
        userToAssign: userToAssign,
      );

      // <-- De la opción 1: Gestión de estado completa
      _selectedIncident = updated;
      final index = _incidents.indexWhere((i) => i.id == incidentId);
      if (index != -1) {
        _incidents[index] = updated;
      }

      return true; // <-- De la opción 2: Comunica el éxito
    } catch (e) {
      _error = e.toString();
      return false; // <-- De la opción 2: Comunica el fallo
    } finally {
      _isAssigning = false;
      notifyListeners();
    }
  }

  Future<void> fetchIncidents(String projectId) async {
    _currentProjectId = projectId; // Guardar para auto-refresh
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _incidents = await _getIncidents.call(projectId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createIncident(Incident incident) async {
    _isCreating = true;
    notifyListeners();
    try {
      await _createIncident.call(incident);
      await fetchIncidents(incident.projectId); // Refrescar la lista
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  Future<void> fetchIncidentById(String incidentId) async {
    _isDetailLoading = true;
    _error = null;
    _selectedIncident = null; // Limpiar el estado anterior
    notifyListeners();
    try {
      _selectedIncident = await _getIncidentById.call(incidentId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }

  // AÑADIR ESTE NUEVO MÉTODO
  Future<bool> closeIncident({
    required String incidentId,
    required String closingNote,
  }) async {
    _isClosing = true;
    notifyListeners();
    try {
      final updatedIncident = await _closeIncident.call(
        incidentId: incidentId,
        closingNote: closingNote,
      );
      _selectedIncident = updatedIncident;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isClosing = false;
      notifyListeners();
    }
  }

  void selectIncidentForDetail(Incident incident) {
    _selectedIncidentForDetail = incident;
    notifyListeners();
  }

  @override
  void dispose() {
    // Remover listener de SyncService al destruir el provider
    _syncService?.removeListener(_onSyncCompleted);
    super.dispose();
  }
}
