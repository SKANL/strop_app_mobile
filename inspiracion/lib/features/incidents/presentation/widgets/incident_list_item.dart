import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/incident_entity.dart';

class IncidentListItem extends StatelessWidget {
  final Incident incident;
  final bool isSelected; // <-- AÑADIR
  final VoidCallback onTap; // <-- MODIFICAR de `GoRouter` a `VoidCallback`

  const IncidentListItem({super.key, required this.incident, required this.onTap, this.isSelected = false}); // <-- AÑADIR isSelected

  @override
  Widget build(BuildContext context) {
    final bool isClosed = incident.status == IncidentStatus.closed;

    return Card(
      color: isSelected ? Theme.of(context).primaryColor.withAlpha(50) : null, // <-- AÑADIR para resaltar
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          isClosed ? Icons.check_circle : Icons.warning,
          color: isClosed ? Colors.green : Colors.orange,
        ),
        title: Text(incident.description),
        subtitle: Text('Reportó: ${incident.author} - ${DateFormat('dd/MM/yyyy').format(incident.reportedDate)}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}