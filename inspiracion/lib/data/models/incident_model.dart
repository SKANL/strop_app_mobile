import '../../domain/entities/incident_entity.dart';

class IncidentModel extends Incident {
  const IncidentModel({
    required super.id,
    required super.projectId,
    required super.description,
    required super.author,
    required super.reportedDate,
    required super.status,
    super.imageUrls, required String assignedToId, required String assignedTo, required String closingNote,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'],
      projectId: json['projectId'],
      description: json['description'],
      author: json['author'],
      reportedDate: DateTime.parse(json['reportedDate']),
      // Convertimos el string del JSON al enum correspondiente.
      status: IncidentStatus.values.firstWhere((e) => e.toString() == 'IncidentStatus.${json['status']}'),
      imageUrls: List<String>.from(json['imageUrls'] ?? []), assignedToId: '', assignedTo: '', closingNote: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'description': description,
      'author': author,
      'reportedDate': reportedDate.toIso8601String(),
      // Convertimos el enum a un string simple.
      'status': status.toString().split('.').last,
      'imageUrls': imageUrls,
    };
  }
}