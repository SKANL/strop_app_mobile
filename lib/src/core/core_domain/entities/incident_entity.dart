// lib/src/core/core_domain/entities/incident_entity.dart
import 'package:equatable/equatable.dart';

/// Entidad de Incidencia/Reporte - Core Domain
class IncidentEntity extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final IncidentType type;
  final IncidentStatus status;
  final IncidentPriority priority;
  
  /// Usuario que creó la incidencia
  final String createdBy;
  final DateTime createdAt;
  
  /// Usuario a quien está asignada la incidencia (para Tareas)
  final String? assignedTo;
  final DateTime? assignedAt;
  
  /// Estado de aprobación (para Reportes bottom-up)
  final ApprovalStatus? approvalStatus;
  final String? approvalNote;
  final String? approvedBy;
  final DateTime? approvedAt;
  
  /// Cierre de incidencia
  final String? closedBy;
  final DateTime? closedAt;
  final String? closeNote;
  
  /// Evidencias
  final List<String> photoUrls;
  final Map<String, dynamic>? gpsData; // {lat, lng, timestamp}
  
  /// Para solicitudes de material
  final MaterialRequest? materialRequest;
  
  const IncidentEntity({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.priority,
    required this.createdBy,
    required this.createdAt,
    this.assignedTo,
    this.assignedAt,
    this.approvalStatus,
    this.approvalNote,
    this.approvedBy,
    this.approvedAt,
    this.closedBy,
    this.closedAt,
    this.closeNote,
    this.photoUrls = const [],
    this.gpsData,
    this.materialRequest,
  });
  
  bool get isOpen => status == IncidentStatus.open;
  bool get isClosed => status == IncidentStatus.closed;
  bool get isCritical => priority == IncidentPriority.critical;
  bool get isAssigned => assignedTo != null;
  bool get isPendingApproval => approvalStatus == ApprovalStatus.pending;
  bool get isApproved => approvalStatus == ApprovalStatus.approved;
  bool get isRejected => approvalStatus == ApprovalStatus.rejected;
  
  @override
  List<Object?> get props => [
    id,
    projectId,
    title,
    description,
    type,
    status,
    priority,
    createdBy,
    createdAt,
    assignedTo,
    assignedAt,
    approvalStatus,
    approvalNote,
    approvedBy,
    approvedAt,
    closedBy,
    closedAt,
    closeNote,
    photoUrls,
    gpsData,
    materialRequest,
  ];
}

/// Tipos de incidencia
enum IncidentType {
  progressReport,    // Reporte de avance
  problem,           // Problema/Falla
  consultation,      // Consulta
  safetyIncident,    // Incidente de seguridad
  materialRequest    // Solicitud de material
}

/// Estados de incidencia
enum IncidentStatus {
  open,   // Abierta
  closed  // Cerrada
}

/// Prioridades
enum IncidentPriority {
  low,      // Baja
  normal,   // Normal
  high,     // Alta
  critical  // Crítica
}

/// Estados de aprobación (para reportes bottom-up)
enum ApprovalStatus {
  pending,   // Pendiente de aprobación
  approved,  // Aprobada
  rejected,  // Rechazada
  assigned   // Asignada como tarea
}

/// Datos de solicitud de material
class MaterialRequest extends Equatable {
  final String itemName;
  final double quantity;
  final String unit;
  final String justification;
  final bool isDeviation; // Excede presupuesto
  
  const MaterialRequest({
    required this.itemName,
    required this.quantity,
    required this.unit,
    required this.justification,
    this.isDeviation = false,
  });
  
  @override
  List<Object?> get props => [itemName, quantity, unit, justification, isDeviation];
}

// Extensiones para conversión
extension IncidentTypeX on IncidentType {
  String toJson() => name;
  
  static IncidentType fromJson(String json) {
    return IncidentType.values.firstWhere(
      (type) => type.name == json,
      orElse: () => IncidentType.problem,
    );
  }
  
  String get displayName {
    switch (this) {
      case IncidentType.progressReport:
        return 'Reporte de Avance';
      case IncidentType.problem:
        return 'Problema / Falla';
      case IncidentType.consultation:
        return 'Consulta';
      case IncidentType.safetyIncident:
        return 'Incidente de Seguridad';
      case IncidentType.materialRequest:
        return 'Solicitud de Material';
    }
  }
}

extension IncidentStatusX on IncidentStatus {
  String toJson() => name;
  
  static IncidentStatus fromJson(String json) {
    return IncidentStatus.values.firstWhere(
      (status) => status.name == json,
      orElse: () => IncidentStatus.open,
    );
  }
}

extension IncidentPriorityX on IncidentPriority {
  String toJson() => name;
  
  static IncidentPriority fromJson(String json) {
    return IncidentPriority.values.firstWhere(
      (priority) => priority.name == json,
      orElse: () => IncidentPriority.normal,
    );
  }
  
  String get displayName {
    switch (this) {
      case IncidentPriority.low:
        return 'Baja';
      case IncidentPriority.normal:
        return 'Normal';
      case IncidentPriority.high:
        return 'Alta';
      case IncidentPriority.critical:
        return 'Crítica';
    }
  }
}

extension ApprovalStatusX on ApprovalStatus {
  String toJson() => name;
  
  static ApprovalStatus fromJson(String json) {
    return ApprovalStatus.values.firstWhere(
      (status) => status.name == json,
      orElse: () => ApprovalStatus.pending,
    );
  }
  
  String get displayName {
    switch (this) {
      case ApprovalStatus.pending:
        return 'Pendiente';
      case ApprovalStatus.approved:
        return 'Aprobada';
      case ApprovalStatus.rejected:
        return 'Rechazada';
      case ApprovalStatus.assigned:
        return 'Asignada';
    }
  }
}
