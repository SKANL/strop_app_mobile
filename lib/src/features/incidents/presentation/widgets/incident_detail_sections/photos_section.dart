import 'package:flutter/material.dart';
import '../incident_photo_gallery.dart';
import 'section_base.dart';

/// Widget de galería de fotos para incident detail
/// 
/// Muestra las fotos de evidencia de la incidencia
/// 
/// SEMANA 2: Widget extraído de incident_detail_screen.dart
/// - Responsabilidad única: mostrar galería de fotos
/// - ~80 líneas
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
        return IncidentPhotoGallery(
          photos: photoUrls,
        );
      },
      errorBuilder: (ctx, err) => Center(child: Text('Error al renderizar fotos')),
    );
  }
}
