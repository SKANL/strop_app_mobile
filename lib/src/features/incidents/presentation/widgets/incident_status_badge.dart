// lib/src/features/incidents/presentation/widgets/incident_status_badge.dart
import 'package:flutter/material.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Widget that displays the status badge for an incident
/// Handles both regular incident status and approval status for material requests
class IncidentStatusBadge extends StatelessWidget {
  final String status;
  final String? approvalStatus;

  const IncidentStatusBadge({
    super.key,
    required this.status,
    this.approvalStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final statusInfo = _getStatusInfo();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: statusInfo.bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        // Use MainAxisSize.min and a loose Flexible so this widget
        // can be placed inside parents that provide unbounded width
        // (for example inside other rows or scrollable constraints).
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusInfo.icon, color: statusInfo.textColor, size: 20),
          const SizedBox(width: 12),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              statusInfo.text,
              style: theme.textTheme.titleSmall?.copyWith(
                color: statusInfo.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo() {
    if (approvalStatus != null) {
      // Approval states (for material requests)
      switch (approvalStatus) {
        case 'pendiente':
          return _StatusInfo(
            bgColor: AppColors.lighten(AppColors.approvalPendingColor, 0.85),
            textColor: AppColors.darken(AppColors.approvalPendingColor, 0.2),
            icon: Icons.hourglass_empty,
            text: 'PENDIENTE DE APROBACIÓN',
          );
        case 'aprobada':
          return _StatusInfo(
            bgColor: AppColors.lighten(AppColors.approvedColor, 0.85),
            textColor: AppColors.darken(AppColors.approvedColor, 0.2),
            icon: Icons.check_circle,
            text: 'SOLICITUD APROBADA',
          );
        case 'rechazada':
          return _StatusInfo(
            bgColor: AppColors.lighten(AppColors.rejectedColor, 0.85),
            textColor: AppColors.darken(AppColors.rejectedColor, 0.2),
            icon: Icons.cancel,
            text: 'SOLICITUD RECHAZADA',
          );
        default:
          return _StatusInfo(
            bgColor: AppColors.lighten(AppColors.iconColor, 0.9),
            textColor: AppColors.darken(AppColors.iconColor, 0.1),
            icon: Icons.help_outline,
            text: 'ESTADO DESCONOCIDO',
          );
      }
    } else {
      // Regular incident states
      switch (status) {
        case 'abierta':
          return _StatusInfo(
            bgColor: AppColors.lighten(AppColors.openStatusColor, 0.85),
            textColor: AppColors.darken(AppColors.openStatusColor, 0.2),
            icon: Icons.radio_button_checked,
            text: 'ABIERTA',
          );
        case 'cerrada':
          return _StatusInfo(
            bgColor: AppColors.lighten(AppColors.closedStatusColor, 0.85),
            textColor: AppColors.darken(AppColors.closedStatusColor, 0.2),
            icon: Icons.check_circle,
            text: 'CERRADA',
          );
        case 'pendiente':
          return _StatusInfo(
            bgColor: AppColors.lighten(AppColors.pendingStatusColor, 0.85),
            textColor: AppColors.darken(AppColors.pendingStatusColor, 0.2),
            icon: Icons.pending,
            text: 'PENDIENTE',
          );
        default:
          return _StatusInfo(
            bgColor: AppColors.lighten(AppColors.iconColor, 0.9),
            textColor: AppColors.darken(AppColors.iconColor, 0.1),
            icon: Icons.help_outline,
            text: 'ESTADO DESCONOCIDO',
          );
      }
    }
  }
}

class _StatusInfo {
  final Color bgColor;
  final Color textColor;
  final IconData icon;
  final String text;

  _StatusInfo({
    required this.bgColor,
    required this.textColor,
    required this.icon,
    required this.text,
  });
}
