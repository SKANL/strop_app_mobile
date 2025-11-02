import 'package:flutter/material.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';
import 'package:mobile_strop_app/src/features/incidents/presentation/widgets/sections/incident_detail_sections/section_base.dart';

/// Widget de galería de fotos para incident detail
/// 
/// Muestra las fotos de evidencia de la incidencia
/// 
/// SEMANA 2: Widget extraído de incident_detail_screen.dart
/// - Responsabilidad única: mostrar galería de fotos
/// - ~80 líneas
/// 
/// OPTIMIZADO: Usa PhotoGrid del core en lugar de IncidentPhotoGallery (widget duplicado eliminado)
class IncidentPhotosSection extends StatelessWidget {
  const IncidentPhotosSection({
    super.key,
    required this.photoUrls,
  });

  final List<String> photoUrls;

  @override
  Widget build(BuildContext context) {
    return DetailSectionBase(
      visible: photoUrls.isNotEmpty,
      title: 'Evidencia Fotográfica',
      leading: const Icon(Icons.photo_library, size: 20),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${photoUrls.length} foto${photoUrls.length > 1 ? "s" : ""}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      builder: (context) {
        return PhotoGrid(
          photos: photoUrls,
          photoSize: 160,
          spacing: 12,
          selectable: true,
          onPhotoSelected: (photo) {
            // TODO: Implementar vista de pantalla completa
          },
        );
      },
      errorBuilder: (ctx, err) => Center(child: Text('Error al renderizar fotos')),
    );
  }
}
