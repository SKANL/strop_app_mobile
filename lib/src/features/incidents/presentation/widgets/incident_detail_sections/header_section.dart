import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/core_domain/entities/incident_entity.dart';
import '../../utils/incident_helpers.dart';
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
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
      ),
    );
  }
  
  Widget _buildTypeChip(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getTypeColor();
    final icon = _getTypeIcon();
    final label = _getTypeLabel();
    
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color),
    );
  }
  
  Color _getTypeColor() {
    switch (incident.type) {
      case IncidentType.problem:
        return Colors.red;
      case IncidentType.progressReport:
        return Colors.blue;
      case IncidentType.consultation:
        return Colors.orange;
      case IncidentType.safetyIncident:
        return Colors.purple;
      case IncidentType.materialRequest:
        return Colors.green;
    }
  }
  
  IconData _getTypeIcon() {
    switch (incident.type) {
      case IncidentType.problem:
        return Icons.warning;
      case IncidentType.progressReport:
        return Icons.trending_up;
      case IncidentType.consultation:
        return Icons.help_outline;
      case IncidentType.safetyIncident:
        return Icons.security;
      case IncidentType.materialRequest:
        return Icons.build;
    }
  }
  
  String _getTypeLabel() {
    return IncidentHelpers.getTypeLabel(incident.type);
  }
  
  String _formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }
}
