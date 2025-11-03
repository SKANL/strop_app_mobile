// lib/src/core/core_ui/widgets/badges/approval_badge.dart

import 'package:flutter/material.dart';
import '../widgets.dart';
import '../../../core_domain/entities/incident_entity.dart';

/// Widget reutilizable para badges de estado de aprobación.
/// 
/// Muestra un badge visual con el estado de aprobación de un reporte/solicitud.
/// 
/// Ejemplo de uso:
/// ```dart
/// ApprovalBadge(status: ApprovalStatus.approved)
/// ```
class ApprovalBadge extends StatelessWidget {
  /// Estado de aprobación a mostrar
  final ApprovalStatus? status;
  
  /// Tamaño del texto
  final double fontSize;
  
  /// Tamaño del icono
  final double iconSize;

  const ApprovalBadge({
    super.key,
    required this.status,
    this.fontSize = 11,
    this.iconSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
  color: AppColors.withOpacity(config.color, 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: iconSize, color: config.color),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig _getConfig(ApprovalStatus? status) {
    switch (status) {
      case ApprovalStatus.pending:
        return _BadgeConfig(
          label: 'PENDIENTE',
          icon: Icons.hourglass_empty,
          color: Colors.orange,
        );
      case ApprovalStatus.approved:
        return _BadgeConfig(
          label: 'APROBADA',
          icon: Icons.check_circle,
          color: Colors.green,
        );
      case ApprovalStatus.rejected:
        return _BadgeConfig(
          label: 'RECHAZADA',
          icon: Icons.cancel,
          color: Colors.red,
        );
      case ApprovalStatus.assigned:
        return _BadgeConfig(
          label: 'ASIGNADA',
          icon: Icons.person,
          color: Colors.blue,
        );
      case null:
        return _BadgeConfig(
          label: 'N/A',
          icon: Icons.help_outline,
          color: Colors.grey,
        );
    }
  }
}

class _BadgeConfig {
  final String label;
  final IconData icon;
  final Color color;

  _BadgeConfig({
    required this.label,
    required this.icon,
    required this.color,
  });
}
