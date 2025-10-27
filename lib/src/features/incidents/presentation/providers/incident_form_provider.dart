// lib/src/features/incidents/presentation/providers/incident_form_provider.dart
import 'package:flutter/foundation.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../../../../core/core_domain/entities/data_state.dart';
import '../../../../core/core_domain/errors/failures.dart';
import '../../../../core/core_domain/repositories/incident_repository.dart';

/// Provider especializado para FORMULARIOS de incidencias
/// 
/// Responsabilidades (SRP):
/// - Crear nuevas incidencias
/// - Asignar incidencias a usuarios
/// - Cerrar incidencias
/// - Gestionar estado de operaciones de escritura
/// 
/// No maneja:
/// - Listas de incidencias (ver IncidentsListProvider)
/// - Detalles/comentarios (ver IncidentDetailProvider)
class IncidentFormProvider extends ChangeNotifier {
  final IncidentRepository repository;

  IncidentFormProvider({required this.repository});

  // ============================================================================
  // ESTADO - Crear Incidencia
  // ============================================================================
  
  DataState<IncidentEntity> _createState = const DataState.initial();
  
  DataState<IncidentEntity> get createState => _createState;
  
  bool get isCreating => _createState.isLoading;
  String? get createError => _createState.failureOrNull?.message;
  IncidentEntity? get createdIncident => _createState.dataOrNull;

  // ============================================================================
  // ESTADO - Asignar Incidencia
  // ============================================================================
  
  DataState<IncidentEntity> _assignState = const DataState.initial();
  
  DataState<IncidentEntity> get assignState => _assignState;
  
  bool get isAssigning => _assignState.isLoading;
  String? get assignError => _assignState.failureOrNull?.message;

  // ============================================================================
  // ESTADO - Cerrar Incidencia
  // ============================================================================
  
  DataState<IncidentEntity> _closeState = const DataState.initial();
  
  DataState<IncidentEntity> get closeState => _closeState;
  
  bool get isClosing => _closeState.isLoading;
  String? get closeError => _closeState.failureOrNull?.message;

  // ============================================================================
  // MÉTODOS PRIVADOS - Validaciones compartidas
  // ============================================================================

  /// Validar y establecer error si falla
  bool _validateAndSetError<T>({
    required bool isValid,
    required String errorMessage,
    required void Function(DataState<T>) setState,
  }) {
    if (!isValid) {
      setState(DataState.error(ValidationFailure(errorMessage)));
      notifyListeners();
      return false;
    }
    return true;
  }

  /// Ejecutar operación genérica con manejo de errores
  Future<bool> _executeOperation<T>({
    required Future<T> Function() operation,
    required void Function(DataState<T>) setState,
    required String errorMessage,
  }) async {
    setState(const DataState.loading());
    notifyListeners();

    try {
      final result = await operation();
      setState(DataState.success(result));
      notifyListeners();
      return true;
    } catch (e) {
      setState(DataState.error(
        UnexpectedFailure(message: '$errorMessage: ${e.toString()}'),
      ));
      notifyListeners();
      return false;
    }
  }

  // ============================================================================
  // MÉTODOS - Crear Incidencia
  // ============================================================================

  /// Crear nueva incidencia
  Future<bool> createIncident(IncidentEntity incident) async {
    // Validaciones
    if (!_validateAndSetError<IncidentEntity>(
      isValid: incident.title.trim().isNotEmpty,
      errorMessage: 'El título es requerido',
      setState: (state) => _createState = state,
    )) {
      return false;
    }

    if (!_validateAndSetError<IncidentEntity>(
      isValid: incident.description.trim().isNotEmpty,
      errorMessage: 'La descripción es requerida',
      setState: (state) => _createState = state,
    )) {
      return false;
    }

    return await _executeOperation(
      operation: () => repository.createIncident(incident),
      setState: (state) => _createState = state,
      errorMessage: 'Error al crear incidencia',
    );
  }

  /// Limpiar estado de creación
  void clearCreateState() {
    _createState = const DataState.initial();
    notifyListeners();
  }

  // ============================================================================
  // MÉTODOS - Asignar Incidencia
  // ============================================================================

  /// Asignar incidencia a un usuario
  Future<bool> assignIncident(String incidentId, String userId) async {
    // Validaciones
    if (!_validateAndSetError<IncidentEntity>(
      isValid: incidentId.trim().isNotEmpty,
      errorMessage: 'ID de incidencia inválido',
      setState: (state) => _assignState = state,
    )) {
      return false;
    }

    if (!_validateAndSetError<IncidentEntity>(
      isValid: userId.trim().isNotEmpty,
      errorMessage: 'ID de usuario inválido',
      setState: (state) => _assignState = state,
    )) {
      return false;
    }

    return await _executeOperation(
      operation: () => repository.assignIncident(incidentId, userId),
      setState: (state) => _assignState = state,
      errorMessage: 'Error al asignar incidencia',
    );
  }

  /// Limpiar estado de asignación
  void clearAssignState() {
    _assignState = const DataState.initial();
    notifyListeners();
  }

  // ============================================================================
  // MÉTODOS - Cerrar Incidencia
  // ============================================================================

  /// Cerrar incidencia con nota de cierre
  Future<bool> closeIncident(String incidentId, String closeNote) async {
    // Validaciones
    if (!_validateAndSetError<IncidentEntity>(
      isValid: incidentId.trim().isNotEmpty,
      errorMessage: 'ID de incidencia inválido',
      setState: (state) => _closeState = state,
    )) {
      return false;
    }

    if (!_validateAndSetError<IncidentEntity>(
      isValid: closeNote.trim().isNotEmpty,
      errorMessage: 'La nota de cierre es requerida',
      setState: (state) => _closeState = state,
    )) {
      return false;
    }

    return await _executeOperation(
      operation: () => repository.closeIncident(incidentId, closeNote),
      setState: (state) => _closeState = state,
      errorMessage: 'Error al cerrar incidencia',
    );
  }

  /// Limpiar estado de cierre
  void clearCloseState() {
    _closeState = const DataState.initial();
    notifyListeners();
  }

  // ============================================================================
  // MÉTODOS - Utilidades
  // ============================================================================

  /// Limpiar todos los estados
  void clear() {
    _createState = const DataState.initial();
    _assignState = const DataState.initial();
    _closeState = const DataState.initial();
    notifyListeners();
  }

  /// Verificar si hay alguna operación en progreso
  bool get hasOperationInProgress {
    return isCreating || isAssigning || isClosing;
  }

  /// Obtener mensaje de error general (si existe)
  String? get generalError {
    return createError ?? assignError ?? closeError;
  }

  /// Verificar si la última operación fue exitosa
  bool get lastOperationSuccessful {
    return _createState.isSuccess || 
           _assignState.isSuccess || 
           _closeState.isSuccess;
  }
}
