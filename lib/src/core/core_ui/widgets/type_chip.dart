// lib/src/core/core_ui/widgets/type_chip.dart

import 'package:flutter/material.dart';
import '../../../core/core_domain/entities/incident_entity.dart';

/// Widget reutilizable para chips de tipo de incidencia.
/// 
/// Muestra un chip visual con el tipo de incidencia/reporte.
/// 
/// Ejemplo de uso:
/// ```dart
/// TypeChip(type: IncidentType.problem)
/// TypeChip(label: 'Avance', color: Colors.blue)
/// ```
class TypeChip extends StatelessWidget {
  /// Tipo de incidencia (usa mapeo automático de color/label)
  final IncidentType? type;
  
  /// Label personalizado (si no se usa `type`)
  final String? label;
  
  /// Color personalizado (si no se usa `type`)
  final Color? color;
  
  /// Tamaño del texto
  final double fontSize;
  
  /// Mostrar icono
  final bool showIcon;

  const TypeChip({
    super.key,
    this.type,
    this.label,
    this.color,
    this.fontSize = 12,
    this.showIcon = false,
  }) : assert(type != null || (label != null && color != null), 
         'Debe proporcionar `type` o `label`+`color`');

  @override
  Widget build(BuildContext context) {
    final config = type != null ? _getConfigFromType(type!) : _BadgeConfig(
      label: label!,
      color: color!,
      icon: Icons.label,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: config.color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(config.icon, size: 14, color: config.color),
            const SizedBox(width: 4),
          ],
          Text(
            config.label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig _getConfigFromType(IncidentType type) {
    switch (type) {
      case IncidentType.progressReport:
        return _BadgeConfig(
          label: 'Avance',
          color: Colors.blue,
          icon: Icons.trending_up,
        );
      case IncidentType.problem:
        return _BadgeConfig(
          label: 'Problema',
          color: Colors.red,
          icon: Icons.warning,
        );
      case IncidentType.consultation:
        return _BadgeConfig(
          label: 'Consulta',
          color: Colors.purple,
          icon: Icons.help,
        );
      case IncidentType.safetyIncident:
        return _BadgeConfig(
          label: 'Seguridad',
          color: Colors.orange,
          icon: Icons.security,
        );
      case IncidentType.materialRequest:
        return _BadgeConfig(
          label: 'Material',
          color: Colors.teal,
          icon: Icons.inventory,
        );
    }
  }
}

class _BadgeConfig {
  final String label;
  final Color color;
  final IconData icon;

  _BadgeConfig({
    required this.label,
    required this.color,
    required this.icon,
  });
}
