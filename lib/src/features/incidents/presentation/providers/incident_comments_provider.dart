// lib/src/features/incidents/presentation/providers/incident_comments_provider.dart
import 'package:flutter/foundation.dart';
import '../../../../core/core_domain/repositories/incident_repository.dart';

/// Provider especializado para gestionar COMENTARIOS de una incidencia
/// 
/// Responsabilidad (SRP):
/// - Agregar comentarios a incidencias
/// - Gestionar estado de carga al agregar comentarios
/// - Mantener errores relacionados con comentarios
/// - Manejar validaciones de comentarios
/// 
/// Separado de: IncidentDetailProvider, IncidentActionsProvider
class IncidentCommentsProvider extends ChangeNotifier {
  final IncidentRepository repository;

  IncidentCommentsProvider({required this.repository});

  // ============================================================================
  // ESTADO - Operaciones de Comentarios
  // ============================================================================

  bool _isAddingComment = false;
  String? _commentError;

  bool get isAddingComment => _isAddingComment;
  String? get commentError => _commentError;

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
    _isAddingComment = false;
    _commentError = null;
    notifyListeners();
  }

  /// Limpiar errores
  void clearError() {
    _commentError = null;
    notifyListeners();
  }
}
