import 'package:flutter/material.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Widget del timeline de eventos para incident detail
/// 
/// Muestra el timeline cronológico de todos los eventos de la incidencia
/// 
/// SEMANA 2: Widget extraído de incident_detail_screen.dart
/// - Responsabilidad única: mostrar timeline
/// - Por ahora simplificado, se completará cuando se refactorice el sistema de timeline
/// - ~60 líneas
class IncidentTimelineEventsSection extends StatelessWidget {
  const IncidentTimelineEventsSection({
    super.key,
    required this.incidentId,
  });

  final String incidentId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timeline, size: 20),
              const SizedBox(width: 8),
              Text(
                'Timeline de Eventos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Mock timeline items
          _buildTimelineItem(
            context,
            icon: Icons.add_circle_outline,
            title: 'Incidencia creada',
            subtitle: 'Se creó la incidencia',
            time: 'Hace 3 horas',
          ),
          const SizedBox(height: 8),
          _buildTimelineItem(
            context,
            icon: Icons.person_add_outlined,
            title: 'Tarea asignada',
            subtitle: 'Se asignó a un usuario',
            time: 'Hace 2 horas',
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimelineItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: Colors.blue.shade700),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
