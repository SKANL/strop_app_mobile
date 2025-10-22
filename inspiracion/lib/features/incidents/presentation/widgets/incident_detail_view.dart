// lib/features/incidents/presentation/widgets/incident_detail_view.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/detail_info_row.dart';
import '../../../../domain/entities/incident_entity.dart';
import '../providers/incident_provider.dart';

class IncidentDetailView extends StatelessWidget {
  final Incident incident;

  const IncidentDetailView({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    // Escuchamos al provider para obtener la incidencia más actualizada
    final provider = context.watch<IncidentProvider>();
    final currentIncident = provider.selectedIncidentForDetail ?? incident;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Incidencia', style: Theme.of(context).textTheme.titleLarge),
        automaticallyImplyLeading: false,
        actions: [
          // Botón para navegar a la pantalla de detalle completa, útil para verla en grande
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Abrir en pantalla completa',
            onPressed: () => context.push('/incident/${currentIncident.id}'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            DetailInfoRow(label: 'Descripción', value: currentIncident.description),
            DetailInfoRow(label: 'Reportado por', value: currentIncident.author),
            DetailInfoRow(
              label: 'Fecha',
              value: DateFormat('dd/MM/yyyy, hh:mm a').format(currentIncident.reportedDate),
            ),
            DetailInfoRow(
              label: 'Estado',
              value: currentIncident.status.toString().split('.').last.toUpperCase(),
            ),
            // ... (Puedes añadir más detalles aquí, como las imágenes)
          ],
        ),
      ),
    );
  }
}