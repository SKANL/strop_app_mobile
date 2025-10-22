// lib/src/features/home/presentation/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      ),
      body: _buildNotificationsList(context),
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
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes notificaciones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: placeholderNotifications.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
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

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: notification.isRead
            ? Colors.grey[300]
            : Theme.of(context).colorScheme.primary.withOpacity(0.2),
        child: Icon(
          _getIconForType(notification.type),
          color: notification.isRead
              ? Colors.grey[600]
              : Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Row(
        children: [
          Text(
            '[${notification.projectName}]',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              notification.title,
              style: TextStyle(
                fontWeight:
                    notification.isRead ? FontWeight.normal : FontWeight.bold,
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
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            notification.message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            _formatTimestamp(notification.timestamp),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
