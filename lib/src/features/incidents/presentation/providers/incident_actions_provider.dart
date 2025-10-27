// lib/src/features/incidents/presentation/providers/incident_actions_provider.dart
import 'package:flutter/foundation.dart';
import '../../../../core/core_domain/repositories/incident_repository.dart';

/// Provider especializado para gestionar ACCIONES sobre incidencias
/// 
/// Responsabilidad (SRP):
/// - Asignar incidencias a usuarios
/// - Cerrar/resolver incidencias
/// - Gestionar estado de carga en acciones
/// - Mantener errores relacionados con acciones
/// 
/// Separado de: IncidentDetailProvider, IncidentCommentsProvider
class IncidentActionsProvider extends ChangeNotifier {
  final IncidentRepository repository;

  IncidentActionsProvider({required this.repository});

  // ============================================================================
  // ESTADO - Operaciones de Acciones
  // ============================================================================

  bool _isPerformingAction = false;
  String? _actionError;

  bool get isPerformingAction => _isPerformingAction;
  String? get actionError => _actionError;

  // ============================================================================
  // MÉTODOS - Asignar Incidencia
  // ============================================================================

  /// Asignar incidencia a un usuario
  Future<bool> assignIncident(String incidentId, String userId) async {
    if (userId.isEmpty) {
      _actionError = 'Debe seleccionar un usuario';
      notifyListeners();
      return false;
    }

    _isPerformingAction = true;
    _actionError = null;
    notifyListeners();

    try {
      await repository.assignIncident(incidentId, userId);
      _isPerformingAction = false;
      notifyListeners();
      return true;
    } catch (e) {
      _actionError = 'Error al asignar incidencia: ${e.toString()}';
      _isPerformingAction = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================================
  // MÉTODOS - Cerrar/Resolver Incidencia
  // ============================================================================

  /// Cerrar/resolver una incidencia
  Future<bool> closeIncident(String incidentId, {String? reason}) async {
    _isPerformingAction = true;
    _actionError = null;
    notifyListeners();

    try {
      await repository.closeIncident(incidentId, reason ?? '');
      _isPerformingAction = false;
      notifyListeners();
      return true;
    } catch (e) {
      _actionError = 'Error al cerrar incidencia: ${e.toString()}';
      _isPerformingAction = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================================
  // MÉTODOS - Utilidades
  // ============================================================================

  /// Limpiar estado
  void clear() {
    _isPerformingAction = false;
    _actionError = null;
    notifyListeners();
  }

  /// Limpiar errores
  void clearError() {
    _actionError = null;
    notifyListeners();
  }
}
