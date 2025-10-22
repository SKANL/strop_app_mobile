// lib/src/features/home/data/models/project_model.dart
import '../../../../core/core_domain/entities/project_entity.dart';

/// Model para Project (capa Data)
/// Mapea JSON de la API/FakeDataSource a Entity
class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String address;
  final String location;
  final String status;
  final String startDate;
  final String estimatedEndDate;
  final double progress;
  final String clientName;
  final Map<String, dynamic>? superintendent;
  final int teamCount;
  final int openIncidents;
  final int pendingApprovals;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.location,
    required this.status,
    required this.startDate,
    required this.estimatedEndDate,
    required this.progress,
    required this.clientName,
    this.superintendent,
    required this.teamCount,
    required this.openIncidents,
    required this.pendingApprovals,
  });

  /// Crear desde JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      location: json['location'] as String? ?? '',
      status: json['status'] as String,
      startDate: json['startDate'] as String,
      estimatedEndDate: json['estimatedEndDate'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      clientName: json['clientName'] as String? ?? '',
      superintendent: json['superintendent'] as Map<String, dynamic>?,
      teamCount: json['teamCount'] as int? ?? 0,
      openIncidents: json['openIncidents'] as int? ?? 0,
      pendingApprovals: json['pendingApprovals'] as int? ?? 0,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'location': location,
      'status': status,
      'startDate': startDate,
      'estimatedEndDate': estimatedEndDate,
      'progress': progress,
      'clientName': clientName,
      'superintendent': superintendent,
      'teamCount': teamCount,
      'openIncidents': openIncidents,
      'pendingApprovals': pendingApprovals,
    };
  }

  /// Mapear a Entity (dominio)
  ProjectEntity toEntity() {
    return ProjectEntity(
      id: id,
      name: name,
      description: description,
      address: address,
      status: _mapStatus(status),
      startDate: DateTime.tryParse(startDate) ?? DateTime.now(),
      endDate: DateTime.tryParse(estimatedEndDate),
      clientName: clientName,
    );
  }

  /// Convertir String status a ProjectStatus enum
  static ProjectStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return ProjectStatus.active;
      case 'paused':
        return ProjectStatus.paused;
      case 'completed':
        return ProjectStatus.completed;
      case 'cancelled':
        return ProjectStatus.cancelled;
      default:
        return ProjectStatus.active;
    }
  }
}
