// lib/src/features/incidents/presentation/widgets/incident_photo_gallery.dart
import 'package:flutter/material.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Widget that displays a horizontal gallery of incident photos
class IncidentPhotoGallery extends StatelessWidget {
  final List<String> photos;
  final VoidCallback? onPhotoTap;

  const IncidentPhotoGallery({
    super.key,
    required this.photos,
    this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (photos.isEmpty) {
      return const SizedBox.shrink();
    }

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
                onTap: onPhotoTap,
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Stack(
                    children: [
                      // Image with error handler
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            photos[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.lighten(AppColors.iconColor, 0.9),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.broken_image,
                                size: 40,
                                color: AppColors.iconColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // GPS overlay
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
}
