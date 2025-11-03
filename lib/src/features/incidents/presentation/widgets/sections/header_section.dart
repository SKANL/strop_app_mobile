import 'package:flutter/material.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/incident_entity.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';
import '../../utils/converters/incident_converters.dart';
import '../../utils/formatters/date_time_formatter.dart';
import '../../utils/constants/incident_type_config.dart';
import 'section_base.dart';

/// Widget de cabecera para incident detail
/// 
/// Muestra: tipo, título, autor, fecha, estado
/// 
/// SEMANA 2: Widget extraído de incident_detail_screen.dart
/// - Responsabilidad única: mostrar información de cabecera
/// - Reutilizable en otros contextos (notificaciones, previews)
/// - ~70 líneas
class IncidentDetailHeaderSection extends StatelessWidget {
  const IncidentDetailHeaderSection({
    super.key,
    required this.incident,
  });

  final IncidentEntity incident;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DetailSectionBase(
      margin: const EdgeInsets.all(16),
      leading: _buildTypeChip(context),
      titleWidget: Text(
        incident.title,
        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      actions: [
        StatusBadge.incidentStatus(
          status: IncidentConverters.getStatusLabel(incident.status),
          useSoftColors: true,
        ),
      ],
      builder: (context) {
        // Author, date and critical banner live in the content area below the uniform header
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Autor y fecha
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Creado por ${incident.createdBy}',
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(
                  _formatDateTime(incident.createdAt),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),

            // Banner crítico
            if (incident.priority == IncidentPriority.critical) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.dangerLight,
                  border: Border.all(color: AppColors.dangerBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: AppColors.dangerIcon, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '¡Incidencia Crítica!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.dangerIcon,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
      errorBuilder: (ctx, err) => Center(child: Text('Error al renderizar cabecera')),
    );
  }

  Widget _buildTypeChip(BuildContext context) {
    final theme = Theme.of(context);
    final typeData = IncidentTypeConfig.getData(incident.type);
    
    return Chip(
      avatar: Icon(typeData.icon, size: 16, color: typeData.color),
      label: Text(
        typeData.label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: typeData.color,
          fontWeight: FontWeight.w600,
        ),
      ),
        backgroundColor: AppColors.withOpacity(typeData.color, 0.1),
      side: BorderSide(color: typeData.color),
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    return DateTimeFormatter.formatDateTime(dateTime);
  }
}
