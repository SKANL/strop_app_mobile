// lib/src/features/home/presentation/screens/settings/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';
import '../../../../../core/core_ui/widgets/layouts/responsive_container.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Marcar todas como leídas',
            onPressed: () {
              // TODO: Implementar marcar todas como leídas
            },
          ),
        ],
      ),
      body: ResponsiveContainer(child: _buildNotificationsList(context)),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    // TODO: Implementar con datos reales
    // Por ahora mostramos placeholder
    final placeholderNotifications = [
      _NotificationItem(
        projectName: 'Torre Reforma',
        title: 'Nueva tarea asignada',
        message: 'El Residente G. te asignó la tarea: "Reparar Fuga P1"',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.taskAssigned,
        isRead: false,
      ),
      _NotificationItem(
        projectName: 'Casa Muestra',
        title: 'Solicitud aprobada',
        message: 'Tu solicitud de cemento ha sido APROBADA',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.requestApproved,
        isRead: true,
      ),
      _NotificationItem(
        projectName: 'Torre Reforma',
        title: 'Comentario nuevo',
        message: 'El Superintendente agregó un comentario en tu reporte',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.comment,
        isRead: true,
      ),
    ];

    if (placeholderNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: AppColors.borderColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes notificaciones',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.iconColor),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      itemCount: placeholderNotifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notification = placeholderNotifications[index];
        return _NotificationTile(
          notification: notification,
          onTap: () {
            // TODO: Navegar al detalle de la incidencia
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Navegación a detalle de incidencia (pendiente)'),
              ),
            );
          },
        );
      },
    );
  }
}

// Modelo temporal para notificaciones
class _NotificationItem {
  final String projectName;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;

  _NotificationItem({
    required this.projectName,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType {
  taskAssigned,
  requestApproved,
  requestRejected,
  comment,
  incidentClosed,
}

// Widget para cada notificación
class _NotificationTile extends StatelessWidget {
  final _NotificationItem notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead
              ? AppColors.borderColor.withOpacity(0.5)
              : AppColors.primary.withOpacity(0.2),
        ),
        boxShadow: [
          if (!notification.isRead)
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: notification.isRead
              ? AppColors.borderColor.withOpacity(0.3)
              : AppColors.primary.withOpacity(0.1),
          child: Icon(
            _getIconForType(notification.type),
            color: notification.isRead
                ? AppColors.iconColor
                : AppColors.primary,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                notification.projectName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead
                      ? FontWeight.w600
                      : FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              _formatTimestamp(notification.timestamp),
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.taskAssigned:
        return Icons.assignment_outlined;
      case NotificationType.requestApproved:
        return Icons.check_circle_outline;
      case NotificationType.requestRejected:
        return Icons.cancel_outlined;
      case NotificationType.comment:
        return Icons.comment_outlined;
      case NotificationType.incidentClosed:
        return Icons.done_all;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inHours < 1) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
