// lib/src/core/core_ui/widgets/timeline_event.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';

/// Widget reutilizable para mostrar eventos en una timeline
/// Usado en: Historial de incidencias, actividad del proyecto, bitácora
/// 
/// **Uso:**
/// ```dart
/// TimelineEvent(
///   title: 'Incidencia creada',
///   timestamp: DateTime.now(),
///   icon: Icons.add_circle,
/// )
/// ```
class TimelineEvent extends StatelessWidget {
  final String title;
  final String? description;
  final DateTime timestamp;
  final IconData icon;
  final Color? iconColor;
  final bool isFirst;
  final bool isLast;

  const TimelineEvent({
    super.key,
    required this.title,
    this.description,
    required this.timestamp,
    required this.icon,
    this.iconColor,
    this.isFirst = false,
    this.isLast = false,
  });

  /// Constructor para evento de asignación
  factory TimelineEvent.assignment({
    required String assignedBy,
    required String assignedTo,
    required DateTime timestamp,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return TimelineEvent(
      title: '$assignedBy asignó esta tarea a $assignedTo',
      timestamp: timestamp,
      icon: Icons.assignment_ind,
      iconColor: AppColors.assignedColor,
      isFirst: isFirst,
      isLast: isLast,
    );
  }

  /// Constructor para evento de comentario
  factory TimelineEvent.comment({
    required String author,
    required String comment,
    required DateTime timestamp,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return TimelineEvent(
      title: '$author agregó un comentario',
      description: comment,
      timestamp: timestamp,
      icon: Icons.comment,
      iconColor: AppColors.iconColor,
      isFirst: isFirst,
      isLast: isLast,
    );
  }

  /// Constructor para evento de cierre
  factory TimelineEvent.closed({
    required String closedBy,
    required String? closeNote,
    required DateTime timestamp,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return TimelineEvent(
      title: '$closedBy cerró esta incidencia',
      description: closeNote,
      timestamp: timestamp,
      icon: Icons.check_circle,
      iconColor: AppColors.closedStatusColor,
      isFirst: isFirst,
      isLast: isLast,
    );
  }

  /// Constructor para evento de aprobación
  factory TimelineEvent.approval({
    required String approver,
    required String status,
    required String? reason,
    required DateTime timestamp,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final statusLower = status.toLowerCase();
    IconData icon;
    Color color;

    if (statusLower == 'aprobada') {
      icon = Icons.check_circle;
      color = AppColors.approvedColor;
    } else if (statusLower == 'rechazada') {
      icon = Icons.cancel;
      color = AppColors.rejectedColor;
    } else {
      icon = Icons.pending;
      color = AppColors.approvalPendingColor;
    }

    return TimelineEvent(
      title: '$approver $status esta solicitud',
      description: reason,
      timestamp: timestamp,
      icon: icon,
      iconColor: color,
      isFirst: isFirst,
      isLast: isLast,
    );
  }

  /// Constructor para evento de aclaración
  factory TimelineEvent.correction({
    required String author,
    required String explanation,
    required DateTime timestamp,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return TimelineEvent(
      title: '$author registró una aclaración',
      description: explanation,
      timestamp: timestamp,
      icon: Icons.info_outline,
      iconColor: AppColors.warning,
      isFirst: isFirst,
      isLast: isLast,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventColor = iconColor ?? AppColors.iconColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line + Icon
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Línea superior
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 16,
                    color: AppColors.borderColor,
                  ),

                // Icono
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.lighten(eventColor, 0.85),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: eventColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: eventColor,
                  ),
                ),

                // Línea inferior
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.borderColor,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Contenido
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Timestamp
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.iconColor,
                    ),
                  ),

                  // Descripción opcional
                  if (description != null && description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lighten(AppColors.iconColor, 0.95),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Text(
                        description!,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para timeline completa (lista de eventos)
/// 
/// **Uso:**
/// ```dart
/// Timeline(
///   events: [
///     TimelineEvent.assignment(...),
///     TimelineEvent.comment(...),
///     TimelineEvent.closed(...),
///   ],
///   emptyWidget: EmptyState(message: 'Sin actividad'),
/// )
/// ```
class Timeline extends StatelessWidget {
  final List<TimelineEvent> events;
  final Widget? emptyWidget;

  const Timeline({
    super.key,
    required this.events,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty && emptyWidget != null) {
      return emptyWidget!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: events.asMap().entries.map((entry) {
        final index = entry.key;
        final event = entry.value;

        return TimelineEvent(
          title: event.title,
          description: event.description,
          timestamp: event.timestamp,
          icon: event.icon,
          iconColor: event.iconColor,
          isFirst: index == 0,
          isLast: index == events.length - 1,
        );
      }).toList(),
    );
  }
}
