// lib/src/core/core_domain/entities/project_entity.dart
import 'package:equatable/equatable.dart';

/// Entidad de Proyecto - Core Domain
class ProjectEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final ProjectStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final String? address;
  final String? clientName;
  
  const ProjectEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.startDate,
    this.endDate,
    this.address,
    this.clientName,
  });
  
  bool get isActive => status == ProjectStatus.active;
  bool get isArchived => status == ProjectStatus.completed || status == ProjectStatus.cancelled;
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    status,
    startDate,
    endDate,
    address,
    clientName,
  ];
}

/// Estados de un proyecto
enum ProjectStatus {
  planning,   // En planeación
  active,     // Activo/En progreso
  paused,     // Pausado
  completed,  // Completado
  cancelled   // Cancelado
}

extension ProjectStatusX on ProjectStatus {
  String toJson() => name;
  
  static ProjectStatus fromJson(String json) {
    return ProjectStatus.values.firstWhere(
      (status) => status.name == json,
      orElse: () => ProjectStatus.active,
    );
  }
  
  String get displayName {
    switch (this) {
      case ProjectStatus.planning:
        return 'En Planeación';
      case ProjectStatus.active:
        return 'Activo';
      case ProjectStatus.paused:
        return 'Pausado';
      case ProjectStatus.completed:
        return 'Completado';
      case ProjectStatus.cancelled:
        return 'Cancelado';
    }
  }
}
