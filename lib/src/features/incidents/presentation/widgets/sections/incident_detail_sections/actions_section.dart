import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/incident_entity.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/user_entity.dart';
import '../../../../../auth/presentation/manager/auth_provider.dart';
import 'section_base.dart';

/// Widget de botones de acción para incident detail
/// 
/// Muestra botones según rol y estado:
/// - Agregar Comentario (siempre)
/// - Asignar Tarea (solo R/S)
/// - Cerrar Incidencia (si eres asignado o R/S)
/// 
/// SEMANA 2: Widget extraído de incident_detail_screen.dart
/// - Responsabilidad única: mostrar botones de acción
/// - ~80 líneas
class IncidentActionsSection extends StatelessWidget {
  const IncidentActionsSection({
    super.key,
    required this.incident,
  });

  final IncidentEntity incident;

  @override
  Widget build(BuildContext context) {
    return DetailSectionBase(
      margin: const EdgeInsets.all(16),
      title: 'Acciones',
      leading: const Icon(Icons.flash_on),
      builder: (context) {
        final authProvider = context.watch<AuthProvider>();
        final currentUser = authProvider.user;

        if (currentUser == null) return const SizedBox.shrink();

        final actions = _getAvailableActions(currentUser, incident);

        if (actions.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: actions.map((action) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton.icon(
                onPressed: () => _handleAction(context, action, incident.id),
                icon: Icon(action.icon),
                label: Text(action.label),
                style: ElevatedButton.styleFrom(
                  backgroundColor: action.color,
                  foregroundColor: Colors.white,
                ),
              ),
            );
          }).toList(),
        );
      },
      errorBuilder: (ctx, err) => Center(child: Text('Error al renderizar acciones')),
    );
  }
  
  List<_ActionButton> _getAvailableActions(UserEntity user, IncidentEntity incident) {
    final actions = <_ActionButton>[];
    
    // Agregar comentario (siempre disponible)
    actions.add(const _ActionButton(
      label: 'Agregar Comentario',
      icon: Icons.comment,
      route: 'add-comment',
      color: Colors.blue,
    ));
    
    // Asignar (solo R/S)
    if (user.role == UserRole.resident || user.role == UserRole.superintendent) {
      if (incident.status == IncidentStatus.open) {
        actions.add(const _ActionButton(
          label: 'Asignar Tarea',
          icon: Icons.person_add,
          route: 'assign',
          color: Colors.orange,
        ));
      }
    }
    
    // Cerrar (si eres asignado o R/S)
    if (incident.assignedTo == user.id || 
        user.role == UserRole.resident || 
        user.role == UserRole.superintendent) {
      if (incident.status == IncidentStatus.open) {
        actions.add(const _ActionButton(
          label: 'Cerrar Incidencia',
          icon: Icons.check_circle,
          route: 'close',
          color: Colors.green,
        ));
      }
    }
    
    return actions;
  }
  
  void _handleAction(BuildContext context, _ActionButton action, String incidentId) {
    // Router defines singular route '/incident/:id/...'.
    // Use the singular path so GoRouter finds the route.
    context.push('/incident/$incidentId/${action.route}');
  }
}

class _ActionButton {
  final String label;
  final IconData icon;
  final String route;
  final Color color;
  
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.route,
    required this.color,
  });
}
