import 'package:flutter/material.dart';
import '../../../../../core/core_domain/entities/incident_entity.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';
import '../../utils/incident_helpers.dart';
import '../../utils/date_time_formatter.dart';
import '../../utils/incident_type_config.dart';
import '../incident_status_badge.dart';

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
    print('[IncidentDetailHeaderSection] build');
    try {
      final theme = Theme.of(context);
      
      return AppCard(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tipo y estado
          Row(
            children: [
              _buildTypeChip(context),
              const Spacer(),
              IncidentStatusBadge(
                status: IncidentHelpers.getStatusLabel(incident.status).toLowerCase(),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Título
          Text(
            incident.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
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
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '¡Incidencia Crítica!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      );
    } catch (e, st) {
      print('[IncidentDetailHeaderSection] build error: $e');
      print(st);
      return Center(child: Text('Error al renderizar cabecera'));
    }
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
      backgroundColor: typeData.color.withValues(alpha: 0.1),
      side: BorderSide(color: typeData.color),
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    return DateTimeFormatter.formatDateTime(dateTime);
  }
}
