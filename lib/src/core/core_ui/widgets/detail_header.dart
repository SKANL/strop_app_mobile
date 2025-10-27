// lib/src/core/core_ui/widgets/detail_header.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import 'status_badge.dart';
import 'info_row.dart';
import 'critical_banner.dart';

/// Widget genérico para header de detalles (incidencias, proyectos, solicitudes)
/// 
/// **Uso:**
/// ```dart
/// DetailHeader(
///   type: 'Avance',
///   title: 'Excavación completada',
///   description: 'Se completó la excavación en sector A',
///   metadata: [
///     DetailMetadata(icon: Icons.person, text: 'Juan Pérez'),
///     DetailMetadata(icon: Icons.calendar, text: '25/10/2025'),
///   ],
/// )
/// ```
class DetailHeader extends StatelessWidget {
  final String type;
  final String title;
  final String description;
  final List<DetailMetadata> metadata;
  final bool isCritical;
  final String? criticalMessage;
  final Color? typeColor;

  const DetailHeader({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.metadata,
    this.isCritical = false,
    this.criticalMessage,
    this.typeColor,
  });

  /// Constructor específico para incidencias (backward compatibility)
  factory DetailHeader.incident({
    required String type,
    required String title,
    required String description,
    required String authorName,
    required DateTime reportedDate,
    String? location,
    bool isCritical = false,
  }) {
    final metadata = <DetailMetadata>[
      DetailMetadata(
        icon: Icons.person_outline,
        text: 'Reportado por: $authorName',
      ),
      DetailMetadata(
        icon: Icons.calendar_today,
        text: DateFormat('dd/MM/yyyy HH:mm').format(reportedDate),
      ),
      if (location != null)
        DetailMetadata(
          icon: Icons.location_on_outlined,
          text: location,
        ),
    ];

    return DetailHeader(
      type: type,
      title: title,
      description: description,
      metadata: metadata,
      isCritical: isCritical,
      criticalMessage: '¡INCIDENCIA CRÍTICA! Requiere atención inmediata.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tipo/Badge
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

        // Metadata (Autor, Fecha, Ubicación, etc)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.lighten(AppColors.iconColor, 0.95),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: metadata.map((item) {
              final isFirst = metadata.first == item;
              return Column(
                children: [
                  if (!isFirst) const SizedBox(height: 8),
                  InfoRowCompact(
                    icon: item.icon,
                    text: item.text,
                  ),
                ],
              );
            }).toList(),
          ),
        ),

        // Badge de crítica si aplica
        if (isCritical) ...[
          const SizedBox(height: 12),
          CriticalBanner(
            message: criticalMessage ?? '¡Requiere atención inmediata!',
            type: CriticalBannerType.error,
          ),
        ],
      ],
    );
  }
}

/// Modelo para metadata del header
class DetailMetadata {
  final IconData icon;
  final String text;

  const DetailMetadata({
    required this.icon,
    required this.text,
  });
}
