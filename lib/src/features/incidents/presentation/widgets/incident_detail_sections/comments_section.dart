import 'package:flutter/material.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Widget de comentarios para incident detail
/// 
/// Muestra la lista de comentarios (futura implementación completa)
/// 
/// SEMANA 2: Widget extraído de incident_detail_screen.dart
/// - Responsabilidad única: mostrar sección de comentarios
/// - Por ahora simplificado, se completará cuando se refactorice el sistema de comentarios
/// - ~50 líneas
class IncidentCommentsListSection extends StatelessWidget {
  const IncidentCommentsListSection({
    super.key,
    required this.incidentId,
  });

  final String incidentId;

  @override
  Widget build(BuildContext context) {
    print('[IncidentCommentsListSection] build');
    try {
      final theme = Theme.of(context);
      
      return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.comment, size: 20),
              const SizedBox(width: 8),
              Text(
                'Comentarios',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Los comentarios aparecerán aquí...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Navegar a pantalla de agregar comentario
            },
            icon: const Icon(Icons.add_comment),
            label: const Text('Agregar Comentario'),
          ),
        ],
      ),
      );
    } catch (e, st) {
      print('[IncidentCommentsListSection] build error: $e');
      print(st);
      return Center(child: Text('Error al renderizar comentarios'));
    }
  }
}

