// lib/src/features/incidents/presentation/widgets/incident_header.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Widget reutilizable para el header de una incidencia
/// Muestra la información principal inalterable
class IncidentHeader extends StatelessWidget {
  final String type;
  final String title;
  final String description;
  final String authorName;
  final DateTime reportedDate;
  final String? location;
  final bool isCritical;

  const IncidentHeader({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.authorName,
    required this.reportedDate,
    this.location,
    this.isCritical = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tipo de incidencia
        StatusBadge.incidentType(type),
        const SizedBox(height: 12),

        // Título
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Descripción
        Text(
          description,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),

        // Metadata (Autor, Fecha, Ubicación)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.lighten(AppColors.iconColor, 0.95),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              InfoRowCompact(
                icon: Icons.person_outline,
                text: 'Reportado por: $authorName',
              ),
              const SizedBox(height: 8),
              InfoRowCompact(
                icon: Icons.calendar_today,
                text: DateFormat('dd/MM/yyyy HH:mm').format(reportedDate),
              ),
              if (location != null) ...[
                const SizedBox(height: 8),
                InfoRowCompact(
                  icon: Icons.location_on_outlined,
                  text: location!,
                ),
              ],
            ],
          ),
        ),

        // Badge de crítica si aplica
        if (isCritical) ...[
          const SizedBox(height: 12),
          CriticalBanner(
            message: '¡INCIDENCIA CRÍTICA! Requiere atención inmediata.',
            type: CriticalBannerType.error,
          ),
        ],
      ],
    );
  }
}
