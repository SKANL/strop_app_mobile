// lib/src/features/incidents/data/models/incident_model.dart
import '../../../../core/core_domain/entities/incident_entity.dart';

/// Model para Incident (capa Data)
/// Mapea JSON de la API/FakeDataSource a Entity
class IncidentModel {
  final String id;
  final String projectId;
  final String type;
  final String title;
  final String description;
  final String authorId;
  final String authorName;
  final String authorRole;
  final String? assignedToId;
  final String? assignedToName;
  final String status;
  final bool isCritical;
  final String createdAt;
  final String? closedAt;
  final String gpsLocation;
  final List<String> photos;
  final String? approvalStatus;
  final Map<String, dynamic>? materialDetails;

  IncidentModel({
    required this.id,
    required this.projectId,
    required this.type,
    required this.title,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    this.assignedToId,
    this.assignedToName,
    required this.status,
    required this.isCritical,
    required this.createdAt,
    this.closedAt,
    required this.gpsLocation,
    required this.photos,
    this.approvalStatus,
    this.materialDetails,
  });

  /// Crear desde JSON
  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorRole: json['authorRole'] as String,
      assignedToId: json['assignedToId'] as String?,
      assignedToName: json['assignedToName'] as String?,
      status: json['status'] as String,
      isCritical: json['isCritical'] as bool? ?? false,
      createdAt: json['createdAt'] as String,
      closedAt: json['closedAt'] as String?,
      gpsLocation: json['gpsLocation'] as String? ?? '',
      photos: (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      approvalStatus: json['approvalStatus'] as String?,
      materialDetails: json['materialDetails'] as Map<String, dynamic>?,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'type': type,
      'title': title,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'assignedToId': assignedToId,
      'assignedToName': assignedToName,
      'status': status,
      'isCritical': isCritical,
      'createdAt': createdAt,
      'closedAt': closedAt,
      'gpsLocation': gpsLocation,
      'photos': photos,
      'approvalStatus': approvalStatus,
      'materialDetails': materialDetails,
    };
  }

  /// Mapear a Entity (dominio)
  IncidentEntity toEntity() {
    return IncidentEntity(
      id: id,
      projectId: projectId,
      type: _mapType(type),
      title: title,
      description: description,
      status: _mapStatus(status),
      priority: isCritical ? IncidentPriority.critical : IncidentPriority.normal,
      createdBy: authorId,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      assignedTo: assignedToId,
      photoUrls: photos,
      gpsData: gpsLocation.isNotEmpty 
          ? {'location': gpsLocation} 
          : null,
      closedAt: closedAt != null ? DateTime.tryParse(closedAt!) : null,
      approvalStatus: approvalStatus != null ? _mapApprovalStatus(approvalStatus!) : null,
      materialRequest: materialDetails != null 
          ? MaterialRequest(
              itemName: materialDetails!['itemName'] as String? ?? '',
              quantity: (materialDetails!['quantity'] as num?)?.toDouble() ?? 0.0,
              unit: materialDetails!['unit'] as String? ?? '',
              justification: materialDetails!['justification'] as String? ?? '',
              isDeviation: materialDetails!['isDeviation'] as bool? ?? false,
            )
          : null,
    );
  }

  /// Convertir String type a IncidentType enum
  static IncidentType _mapType(String type) {
    switch (type.toLowerCase()) {
      case 'avance':
        return IncidentType.progressReport;
      case 'problema':
        return IncidentType.problem;
      case 'consulta':
        return IncidentType.consultation;
      case 'seguridad':
        return IncidentType.safetyIncident;
      case 'material':
        return IncidentType.materialRequest;
      default:
        return IncidentType.problem;
    }
  }

  /// Convertir String status a IncidentStatus enum
  static IncidentStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'abierta':
        return IncidentStatus.open;
      case 'cerrada':
        return IncidentStatus.closed;
      default:
        return IncidentStatus.open;
    }
  }

  /// Convertir String approvalStatus a ApprovalStatus enum
  static ApprovalStatus _mapApprovalStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'pendiente':
        return ApprovalStatus.pending;
      case 'approved':
      case 'aprobada':
        return ApprovalStatus.approved;
      case 'rejected':
      case 'rechazada':
        return ApprovalStatus.rejected;
      case 'assigned':
      case 'asignada':
        return ApprovalStatus.assigned;
      default:
        return ApprovalStatus.pending;
    }
  }
}
