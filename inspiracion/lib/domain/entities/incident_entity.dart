import 'package:equatable/equatable.dart';

// Un enum para representar los posibles estados de una incidencia.
enum IncidentStatus { open, assigned, closed }

class Incident extends Equatable {
  final String id;
  final String projectId; // Para saber a qué proyecto pertenece
  final String description;
  final String author; // Quién la reportó
  final DateTime reportedDate;
  final IncidentStatus status;
  final List<String> imageUrls; // URLs de las imágenes asociadas a la incidencia
  final String? assignedTo; // <-- AÑADIR: Nombre del responsable
  final String? assignedToId; // <-- AÑADIR: ID del responsable
  final String? closingNote;

  const Incident({
    required this.id,
    required this.projectId,
    required this.description,
    required this.author,
    required this.reportedDate,
    required this.status,
    this.imageUrls = const [],
    this.assignedTo,
    this.assignedToId,
    this.closingNote,
  });

  @override
  List<Object?> get props => [id, projectId, description, author, reportedDate, status, imageUrls, assignedTo, assignedToId, closingNote,];
}