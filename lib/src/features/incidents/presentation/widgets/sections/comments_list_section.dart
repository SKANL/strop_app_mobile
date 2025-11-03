import 'package:flutter/material.dart';
import 'section_base.dart';
import 'package:mobile_strop_app/src/core/core_ui/theme/app_colors.dart';

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
    return DetailSectionBase(
      margin: const EdgeInsets.all(16),
      title: 'Comentarios',
      leading: const Icon(Icons.comment, size: 20),
      builder: (context) {
        final theme = Theme.of(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Los comentarios aparecerán aquí...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted,
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
        );
      },
      errorBuilder: (ctx, err) => Center(child: Text('Error al renderizar comentarios')),
    );
  }
}

