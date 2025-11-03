import 'package:flutter/material.dart';
import 'package:mobile_strop_app/src/core/core_ui/theme/app_colors.dart';
import 'section_base.dart';

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
    return DetailSectionBase(
      margin: const EdgeInsets.all(16),
      title: 'Timeline de Eventos',
      leading: const Icon(Icons.timeline, size: 20),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
        );
      },
      errorBuilder: (ctx, err) => Center(child: Text('Error al renderizar timeline')),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon container
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.infoDark),
          ),
        ),

        const SizedBox(width: 12),

        // Title + subtitle
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
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),

        // Time
        Text(
          time,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
