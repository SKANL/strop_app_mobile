import '../../domain/entities/project_entity.dart';

/// Representa un proyecto pendiente de sincronización con metadata adicional
class PendingProjectData {
  final Project project;
  final DateTime createdAt;
  final DateTime lastModifiedAt;

  PendingProjectData({
    required this.project,
    required this.createdAt,
    required this.lastModifiedAt,
  });
}
