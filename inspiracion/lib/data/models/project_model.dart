import '../../domain/entities/project_entity.dart';

/// El Modelo representa los datos tal como provienen de la fuente (ej. API).
/// Extiende la Entidad para heredar sus propiedades, pero añade la lógica de datos.
class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.location,
    required super.startDate,
    required super.endDate,
  });

  /// Un 'factory constructor' que crea una instancia de ProjectModel desde un mapa JSON.
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      // Convertimos la fecha de String a DateTime
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  /// Un método que convierte nuestra instancia de ProjectModel a un mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      // Convertimos la fecha de DateTime a String en formato ISO 8601
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}