// lib/src/core/core_ui/widgets/status_badge.dart
import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar badges de estado
/// Usado en: Incidencias, Reportes, Aprobaciones
class StatusBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final bool isOutlined;

  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.padding,
    this.isOutlined = false,
  });

  /// Constructor para estados de incidencia
  factory StatusBadge.incidentStatus(String status, {bool? isCritical}) {
    final statusLower = status.toLowerCase();
    Color backgroundColor;
    IconData? icon;

    if (isCritical == true) {
      backgroundColor = Colors.red;
      icon = Icons.warning;
    } else if (statusLower == 'abierta') {
      backgroundColor = Colors.blue;
      icon = Icons.circle_outlined;
    } else if (statusLower == 'en progreso') {
      backgroundColor = Colors.orange;
      icon = Icons.hourglass_empty;
    } else if (statusLower == 'cerrada') {
      backgroundColor = Colors.green;
      icon = Icons.check_circle;
    } else {
      backgroundColor = Colors.grey;
      icon = Icons.help_outline;
    }

    return StatusBadge(
      label: isCritical == true ? '🔥 $status (CRÍTICA)' : status,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      icon: icon,
    );
  }

  /// Constructor para estados de aprobación
  factory StatusBadge.approvalStatus(String approvalStatus) {
    final statusLower = approvalStatus.toLowerCase();
    Color backgroundColor;
    IconData icon;
    String label;

    if (statusLower == 'pendiente') {
      backgroundColor = Colors.orange;
      icon = Icons.schedule;
      label = 'PENDIENTE';
    } else if (statusLower == 'aprobada') {
      backgroundColor = Colors.green;
      icon = Icons.check_circle;
      label = 'APROBADA';
    } else if (statusLower == 'rechazada') {
      backgroundColor = Colors.red;
      icon = Icons.cancel;
      label = 'RECHAZADA';
    } else if (statusLower == 'asignada') {
      backgroundColor = Colors.blue;
      icon = Icons.assignment_ind;
      label = 'ASIGNADA';
    } else {
      backgroundColor = Colors.grey;
      icon = Icons.help_outline;
      label = approvalStatus.toUpperCase();
    }

    return StatusBadge(
      label: label,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      icon: icon,
    );
  }

  /// Constructor para tipos de incidencia
  factory StatusBadge.incidentType(String type) {
    final typeLower = type.toLowerCase();
    Color backgroundColor;
    IconData icon;

    if (typeLower == 'avance') {
      backgroundColor = Colors.blue.shade100;
      icon = Icons.trending_up;
    } else if (typeLower == 'problema') {
      backgroundColor = Colors.red.shade100;
      icon = Icons.warning_amber;
    } else if (typeLower == 'consulta') {
      backgroundColor = Colors.purple.shade100;
      icon = Icons.help_outline;
    } else if (typeLower == 'seguridad') {
      backgroundColor = Colors.orange.shade100;
      icon = Icons.security;
    } else if (typeLower == 'material') {
      backgroundColor = Colors.green.shade100;
      icon = Icons.inventory_2;
    } else {
      backgroundColor = Colors.grey.shade200;
      icon = Icons.label;
    }

    return StatusBadge(
      label: type,
      backgroundColor: backgroundColor,
      textColor: Colors.black87,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    );

    final container = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: isOutlined ? null : backgroundColor,
        border: isOutlined ? Border.all(
          color: backgroundColor ?? Colors.grey,
          width: 1.5,
        ) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: isOutlined ? backgroundColor : textColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: isOutlined ? backgroundColor : textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    return container;
  }
}
