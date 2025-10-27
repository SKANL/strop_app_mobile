import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/core_ui/theme/app_colors.dart';

/// Widget para capturar y mostrar evidencia fotográfica
class EvidencePhotoSection extends StatelessWidget {
  final List<XFile> images;
  final Function(int index) onRemoveImage;
  final Function(ImageSource) onPickImage;
  final int maxImages;

  const EvidencePhotoSection({
    super.key,
    required this.images,
    required this.onRemoveImage,
    required this.onPickImage,
    this.maxImages = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.photo_camera, color: AppColors.iconColor),
            const SizedBox(width: 8),
            Text(
              'Evidencia Fotográfica (Opcional)',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Text(
              '${images.length}/$maxImages',
              style: TextStyle(fontSize: 12, color: AppColors.iconColor),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: images.length < maxImages ? () => onPickImage(ImageSource.camera) : null,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Cámara'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: images.length < maxImages ? () => onPickImage(ImageSource.gallery) : null,
                icon: const Icon(Icons.photo_library),
                label: const Text('Galería'),
              ),
            ),
          ],
        ),
        
        if (images.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(images[index].path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 12,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.error,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close, size: 14, color: Colors.white),
                          onPressed: () => onRemoveImage(index),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
