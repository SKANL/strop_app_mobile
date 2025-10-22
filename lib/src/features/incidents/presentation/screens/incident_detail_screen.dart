import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/manager/auth_provider.dart';
import '../providers/incidents_provider.dart';
import '../widgets/incident_header.dart';
import '../widgets/timeline_event.dart';

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
                  IncidentHeader(
                    type: incident['type'],
                    title: incident['title'] ?? 'Sin título',
                    description: incident['description'] ?? '',
                    authorName: incident['author'] ?? 'Desconocido',
                    reportedDate: incident['createdAt'],
                    location: incident['gpsLocation'],
                    isCritical: incident['isCritical'] == true,
                  ),
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
                  Timeline(
                    events: _mockTimeline.map((e) {
                      final type = e['type'] as String;
                      switch (type) {
                        case 'assigned':
                          return TimelineEvent.assignment(
                            assignedBy: e['actor'],
                            assignedTo: e['description'] ?? '',
                            timestamp: e['timestamp'],
                          );
                        case 'comment':
                          return TimelineEvent.comment(
                            author: e['actor'],
                            comment: e['description'],
                            timestamp: e['timestamp'],
                          );
                        case 'correction':
                          return TimelineEvent.correction(
                            author: e['actor'],
                            explanation: e['description'],
                            timestamp: e['timestamp'],
                          );
                        case 'created':
                        default:
                          return TimelineEvent(
                            title: '${e['actor']} ${e['description']}',
                            timestamp: e['timestamp'],
                            icon: Icons.add_circle,
                          );
                      }
                    }).toList(),
                    emptyWidget: const SizedBox.shrink(),
                  ),
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

  // Header is provided by the reusable IncidentHeader widget in the build method.

  // Metadata rows are rendered by the IncidentHeader widget; helper removed.

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
                    image: null,
                  ),
                  child: Stack(
                    children: [
                      // Image (network) with error handler to avoid crashes when offline
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            photos[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
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
                                  Colors.black.withAlpha((0.7 * 255).round()),
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

  // Timeline is rendered with the reusable Timeline widget in the build method.

  // TimelineEvent rendering is handled by the reusable TimelineEvent widget.

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
    
  // Determinar si el usuario actual es el asignado (placeholder: compara nombres cuando existan)
  final assignedToText = incident['assignedTo']?.toString() ?? '';
  final isAssigned = user != null && assignedToText.isNotEmpty && assignedToText.contains(user.name);
    
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

  void _submitComment() async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    final provider = context.read<IncidentsProvider>();
    final ok = await provider.addComment(widget.incidentId, comment);
    if (!mounted) return;

    if (ok) {
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comentario agregado')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al agregar comentario')));
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

}
