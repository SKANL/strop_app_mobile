import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/manager/auth_provider.dart';

/// Screen 19: Detalle de Incidencia
/// 
/// La pantalla más densa. Muestra la vida completa de UNA incidencia:
/// - Cabecera inalterable (tipo, título, autor, fecha, fotos originales)
/// - Estado visual (Abierta, Cerrada, Pendiente Aprobación, Aprobada, Rechazada)
/// - Timeline cronológico de todos los eventos (RF-C04)
/// - Botones dinámicos según rol y estado del usuario
/// 
/// Botones de acción:
/// - [Agregar Comentario]: Siempre visible
/// - [Registrar Aclaración]: Siempre visible (RF-C04)
/// - [Asignar Tarea]: Solo visible para R/S (RF-B03)
/// - [Cerrar Incidencia]: Solo si eres asignado O un R/S superior (RF-B04)
class IncidentDetailScreen extends StatefulWidget {
  final String incidentId;

  const IncidentDetailScreen({
    super.key,
    required this.incidentId,
  });

  @override
  State<IncidentDetailScreen> createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  // TODO: Reemplazar con datos reales del Provider
  final Map<String, dynamic> _mockIncident = {
    'id': '1',
    'type': 'problema',
    'title': 'Fuga de agua en tubería principal',
    'description': 'Se detectó una fuga considerable en la tubería del segundo piso. El agua está afectando el área de trabajo.',
    'author': 'Juan Pérez (Cabo)',
    'assignedTo': 'Carlos López (Cabo)',
    'createdAt': DateTime.now().subtract(const Duration(hours: 3)),
    'status': 'abierta', // abierta, cerrada, pendiente, aprobada, rechazada
    'isCritical': true,
    'photos': [
      'https://via.placeholder.com/300x200/FF5722/FFFFFF?text=Foto+1',
      'https://via.placeholder.com/300x200/FF5722/FFFFFF?text=Foto+2',
    ],
    'gpsLocation': '19.4326, -99.1332',
    'approvalStatus': null, // pendiente, aprobada, rechazada
  };

  final List<Map<String, dynamic>> _mockTimeline = [
    {
      'type': 'created',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'actor': 'Juan Pérez (Cabo)',
      'description': 'creó esta incidencia',
    },
    {
      'type': 'assigned',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
      'actor': 'Residente González',
      'description': 'asignó esta tarea a Carlos López',
    },
    {
      'type': 'comment',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      'actor': 'Carlos López (Cabo)',
      'description': 'Ya localicé la fuga. Necesito materiales para repararla.',
    },
    {
      'type': 'correction',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 45)),
      'actor': 'Juan Pérez (Cabo)',
      'description': 'Aclaración: La fuga está en el piso 3, no en el 2',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final incident = _mockIncident;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTypeLabel(incident['type'])),
        actions: [
          // Menú de opciones adicionales
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'share') {
                // TODO: Implementar compartir
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Compartir'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Contenido scrolleable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabecera inalterable
                  _buildHeader(theme, incident),
                  const SizedBox(height: 24),

                  // Estado visual
                  _buildStatusBadge(theme, incident),
                  const SizedBox(height: 24),

                  // Descripción original
                  _buildDescriptionSection(theme, incident),
                  const SizedBox(height: 24),

                  // Galería de fotos
                  if (incident['photos'] != null && (incident['photos'] as List).isNotEmpty)
                    _buildPhotoGallery(theme, incident['photos']),
                  
                  if (incident['photos'] != null && (incident['photos'] as List).isNotEmpty)
                    const SizedBox(height: 24),

                  // Timeline de eventos
                  _buildTimeline(theme),
                  const SizedBox(height: 80), // Espacio para el campo de comentario
                ],
              ),
            ),
          ),

          // Campo de comentario (persistente)
          _buildCommentInputBar(theme),
        ],
      ),
      
      // Botones de acción flotantes
      floatingActionButton: _buildActionButtons(context, incident),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildHeader(ThemeData theme, Map<String, dynamic> incident) {
    final color = _getTypeColor(incident['type']);
    final icon = _getTypeIcon(incident['type']);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tipo e ID
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                _getTypeLabel(incident['type']),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (incident['isCritical'] == true)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'CRÍTICA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Título
          Text(
            incident['title'] ?? 'Sin título',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          const Divider(),
          const SizedBox(height: 8),

          // Metadatos
          _buildMetadataRow(Icons.person_outline, 'Creado por', incident['author']),
          const SizedBox(height: 4),
          if (incident['assignedTo'] != null)
            _buildMetadataRow(Icons.assignment_ind, 'Asignado a', incident['assignedTo']),
          if (incident['assignedTo'] != null)
            const SizedBox(height: 4),
          _buildMetadataRow(
            Icons.schedule,
            'Fecha',
            DateFormat('dd/MM/yyyy HH:mm').format(incident['createdAt']),
          ),
          const SizedBox(height: 4),
          _buildMetadataRow(
            Icons.location_on_outlined,
            'Ubicación GPS',
            incident['gpsLocation'] ?? 'No disponible',
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(ThemeData theme, Map<String, dynamic> incident) {
    final status = incident['status'] as String;
    final approval = incident['approvalStatus'] as String?;

    Color bgColor;
    Color textColor;
    IconData icon;
    String text;

    if (approval != null) {
      // Estados de aprobación (para solicitudes de material)
      switch (approval) {
        case 'pendiente':
          bgColor = Colors.orange[100]!;
          textColor = Colors.orange[900]!;
          icon = Icons.hourglass_empty;
          text = 'PENDIENTE DE APROBACIÓN';
          break;
        case 'aprobada':
          bgColor = Colors.green[100]!;
          textColor = Colors.green[900]!;
          icon = Icons.check_circle;
          text = 'SOLICITUD APROBADA';
          break;
        case 'rechazada':
          bgColor = Colors.red[100]!;
          textColor = Colors.red[900]!;
          icon = Icons.cancel;
          text = 'SOLICITUD RECHAZADA';
          break;
        default:
          bgColor = Colors.grey[200]!;
          textColor = Colors.grey[800]!;
          icon = Icons.help_outline;
          text = 'ESTADO DESCONOCIDO';
      }
    } else {
      // Estados normales de incidencia
      switch (status) {
        case 'abierta':
          bgColor = Colors.blue[100]!;
          textColor = Colors.blue[900]!;
          icon = Icons.lock_open;
          text = 'ABIERTA';
          break;
        case 'cerrada':
          bgColor = Colors.green[100]!;
          textColor = Colors.green[900]!;
          icon = Icons.check_circle;
          text = 'CERRADA';
          break;
        case 'pendiente':
          bgColor = Colors.orange[100]!;
          textColor = Colors.orange[900]!;
          icon = Icons.pending;
          text = 'PENDIENTE';
          break;
        default:
          bgColor = Colors.grey[200]!;
          textColor = Colors.grey[800]!;
          icon = Icons.help_outline;
          text = 'DESCONOCIDO';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ThemeData theme, Map<String, dynamic> incident) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          incident['description'] ?? 'Sin descripción',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildPhotoGallery(ThemeData theme, List photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Evidencia fotográfica (${photos.length})',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // TODO: Abrir visor de imagen fullscreen
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                    image: DecorationImage(
                      image: NetworkImage(photos[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Overlay con info de GPS/timestamp
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const Text(
                            '📍 GPS estampado',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historial de actividad',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _mockTimeline.length,
          itemBuilder: (context, index) {
            final event = _mockTimeline[index];
            return _buildTimelineEvent(theme, event, index == _mockTimeline.length - 1);
          },
        ),
      ],
    );
  }

  Widget _buildTimelineEvent(ThemeData theme, Map<String, dynamic> event, bool isLast) {
    final type = event['type'] as String;
    Color iconColor;
    IconData icon;

    switch (type) {
      case 'created':
        iconColor = Colors.blue;
        icon = Icons.add_circle;
        break;
      case 'assigned':
        iconColor = Colors.purple;
        icon = Icons.assignment_ind;
        break;
      case 'comment':
        iconColor = Colors.teal;
        icon = Icons.comment;
        break;
      case 'correction':
        iconColor = Colors.orange;
        icon = Icons.edit_note;
        break;
      case 'closed':
        iconColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'approved':
        iconColor = Colors.green;
        icon = Icons.thumb_up;
        break;
      case 'rejected':
        iconColor = Colors.red;
        icon = Icons.thumb_down;
        break;
      default:
        iconColor = Colors.grey;
        icon = Icons.circle;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Línea vertical del timeline
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey[300],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          
          // Contenido del evento
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: event['actor'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' ${event['description']}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatRelativeTime(event['timestamp']),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInputBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Agregar un comentario...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              color: theme.colorScheme.primary,
              onPressed: () {
                if (_commentController.text.trim().isNotEmpty) {
                  _submitComment();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Map<String, dynamic> incident) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    
    // Determinar qué botones mostrar según rol y estado
    final userRole = user?.role.toString().split('.').last ?? '';
    final isResidentOrSuper = ['resident', 'superintendent', 'superadmin', 'owner'].contains(userRole);
    final status = incident['status'] as String;
    final isClosed = status == 'cerrada';
    
    // TODO: Verificar si el usuario es el asignado
    final isAssigned = true; // Placeholder
    
    final canAssign = isResidentOrSuper && !isClosed;
    final canClose = !isClosed && (isAssigned || isResidentOrSuper);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Botón Asignar (solo R/S)
        if (canAssign)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FloatingActionButton.extended(
              heroTag: 'assign',
              onPressed: () {
                context.push('/incident/${widget.incidentId}/assign?projectId=1');
              },
              backgroundColor: Colors.purple,
              icon: const Icon(Icons.person_add),
              label: const Text('Asignar'),
            ),
          ),
        
        // Botón Aclaración (siempre visible)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FloatingActionButton.extended(
            heroTag: 'correction',
            onPressed: () {
              context.push('/incident/${widget.incidentId}/correction');
            },
            backgroundColor: Colors.orange,
            icon: const Icon(Icons.edit_note),
            label: const Text('Aclaración'),
          ),
        ),
        
        // Botón Cerrar (solo asignado o R/S)
        if (canClose)
          FloatingActionButton.extended(
            heroTag: 'close',
            onPressed: () {
              context.push('/incident/${widget.incidentId}/close');
            },
            backgroundColor: Colors.green,
            icon: const Icon(Icons.check_circle),
            label: const Text('Cerrar'),
          ),
      ],
    );
  }

  void _submitComment() {
    // TODO: Implementar envío de comentario con Provider
    final comment = _commentController.text.trim();
    print('Comentario: $comment');
    
    // Limpiar campo
    _commentController.clear();
    
    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comentario agregado')),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'avance':
        return Colors.blue;
      case 'problema':
        return Colors.orange;
      case 'consulta':
        return Colors.purple;
      case 'seguridad':
        return Colors.red;
      case 'material':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'avance':
        return Icons.trending_up;
      case 'problema':
        return Icons.warning;
      case 'consulta':
        return Icons.help_outline;
      case 'seguridad':
        return Icons.security;
      case 'material':
        return Icons.inventory_2;
      default:
        return Icons.description;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'avance':
        return 'Reporte de Avance';
      case 'problema':
        return 'Problema / Falla';
      case 'consulta':
        return 'Consulta';
      case 'seguridad':
        return 'Incidente de Seguridad';
      case 'material':
        return 'Solicitud de Material';
      default:
        return 'Incidencia';
    }
  }

  String _formatRelativeTime(DateTime timestamp) {
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
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }
}
