import 'package:flutter/material.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';
import '../incident_photo_gallery.dart';

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
    print('[IncidentPhotosSection] build');
    try {
      if (photoUrls.isEmpty) return const SizedBox.shrink();
      
      final theme = Theme.of(context);
      
      return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.photo_library, size: 20),
              const SizedBox(width: 8),
              Text(
                'Evidencia Fotográfica',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${photoUrls.length} foto${photoUrls.length > 1 ? "s" : ""}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          IncidentPhotoGallery(
            photos: photoUrls,
          ),
        ],
      ),
      );
    } catch (e, st) {
      print('[IncidentPhotosSection] build error: $e');
      print(st);
      return Center(child: Text('Error al renderizar fotos'));
    }
  }
}
