// lib/src/features/incidents/presentation/providers/incident_detail_provider.dart
import 'package:flutter/foundation.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../../../../core/core_domain/entities/data_state.dart';
import '../../../../core/core_domain/errors/failures.dart';
import '../../../../core/core_domain/repositories/incident_repository.dart';

/// Provider especializado para gestionar DETALLES de una incidencia
/// 
/// Responsabilidades (SRP):
/// - Cargar y mantener estado de una incidencia específica
/// - Agregar comentarios a la incidencia
/// - Agregar aclaraciones/correcciones
/// - Gestionar estado de loading/error para operaciones de detalle
/// 
/// No maneja:
/// - Listas de incidencias (ver IncidentsListProvider)
/// - Creación/cierre de incidencias (ver IncidentFormProvider)
class IncidentDetailProvider extends ChangeNotifier {
  final IncidentRepository repository;

  IncidentDetailProvider({required this.repository});

  // ============================================================================
  // ESTADO - Detalle de Incidencia (con DataState)
  // ============================================================================
  
  DataState<IncidentEntity> _incidentState = const DataState.initial();
  
  DataState<IncidentEntity> get incidentState => _incidentState;
  
  IncidentEntity? get incident => _incidentState.dataOrNull;
  bool get isLoading => _incidentState.isLoading;
  String? get error => _incidentState.failureOrNull?.message;
  bool get hasData => _incidentState.isSuccess;

  // ============================================================================
  // ESTADO - Operaciones (Comentarios, Correcciones)
  // ============================================================================
  
  bool _isAddingComment = false;
  String? _commentError;

  bool get isAddingComment => _isAddingComment;
  String? get commentError => _commentError;

  // ============================================================================
  // MÉTODOS - Cargar Detalle
  // ============================================================================

  /// Cargar detalle de incidencia por ID
  Future<void> loadIncidentDetail(String incidentId) async {
    print('[IncidentDetailProvider] Iniciando carga de incidencia: $incidentId');
    _incidentState = const DataState.loading();
    notifyListeners();

    try {
      print('[IncidentDetailProvider] Llamando al repositorio...');
      final incident = await repository.getIncidentById(incidentId);
      print('[IncidentDetailProvider] Incidencia cargada exitosamente: ${incident.title}');
      _incidentState = DataState.success(incident);
      notifyListeners();
      print('[IncidentDetailProvider] Estado actualizado a success');
    } catch (e, stackTrace) {
      print('[IncidentDetailProvider] Error al cargar detalle: $e');
      print('[IncidentDetailProvider] StackTrace: $stackTrace');
      _incidentState = DataState.error(
        UnexpectedFailure(
          message: 'Error al cargar detalle: ${e.toString()}',
        ),
      );
      notifyListeners();
    }
  }

  /// Refrescar detalle actual
  Future<void> refresh() async {
    if (incident != null) {
      await loadIncidentDetail(incident!.id);
    }
  }

  /// Establecer incidencia desde la lista (evita fetch innecesario)
  void setIncident(IncidentEntity incident) {
    _incidentState = DataState.success(incident);
    notifyListeners();
  }

  // ============================================================================
  // MÉTODOS - Agregar Comentario
  // ============================================================================

  /// Agregar comentario a la incidencia
  Future<bool> addComment(String incidentId, String comment) async {
    if (comment.trim().isEmpty) {
      _commentError = 'El comentario no puede estar vacío';
      notifyListeners();
      return false;
    }

    _isAddingComment = true;
    _commentError = null;
    notifyListeners();

    try {
      await repository.addComment(incidentId, comment);
      
      // Recargar detalle para mostrar el comentario
      await loadIncidentDetail(incidentId);
      
      _isAddingComment = false;
      notifyListeners();
      return true;
    } catch (e) {
      _commentError = 'Error al agregar comentario: ${e.toString()}';
      _isAddingComment = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================================
  // MÉTODOS - Agregar Aclaración/Corrección
  // ============================================================================

  /// Agregar aclaración o corrección a la incidencia
  Future<bool> addCorrection(String incidentId, String correction) async {
    if (correction.trim().isEmpty) {
      _commentError = 'La aclaración no puede estar vacía';
      notifyListeners();
      return false;
    }

    _isAddingComment = true;
    _commentError = null;
    notifyListeners();

    try {
      await repository.addCorrection(incidentId, correction);
      
      // Recargar detalle para mostrar la aclaración
      await loadIncidentDetail(incidentId);
      
      _isAddingComment = false;
      notifyListeners();
      return true;
    } catch (e) {
      _commentError = 'Error al agregar aclaración: ${e.toString()}';
      _isAddingComment = false;
      notifyListeners();
      return false;
    }
  }

  // ============================================================================
  // MÉTODOS - Utilidades
  // ============================================================================

  /// Limpiar estado
  void clear() {
    _incidentState = const DataState.initial();
    _isAddingComment = false;
    _commentError = null;
    notifyListeners();
  }

  /// Verificar si la incidencia está cerrada
  bool get isClosed {
    return incident?.status == IncidentStatus.closed;
  }

  /// Verificar si la incidencia está asignada
  bool get isAssigned {
    return incident?.assignedTo != null;
  }

  /// Obtener usuario asignado
  String? get assignedToUser {
    return incident?.assignedTo;
  }

  /// Obtener estado de aprobación
  ApprovalStatus? get approvalStatus {
    return incident?.approvalStatus;
  }

  /// Verificar si está pendiente de aprobación
  bool get isPendingApproval {
    return incident?.approvalStatus == ApprovalStatus.pending;
  }

  /// Verificar si está aprobado
  bool get isApproved {
    return incident?.approvalStatus == ApprovalStatus.approved;
  }

  /// Verificar si está rechazado
  bool get isRejected {
    return incident?.approvalStatus == ApprovalStatus.rejected;
  }
}
