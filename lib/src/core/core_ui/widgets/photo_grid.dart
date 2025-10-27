// lib/src/core/core_ui/widgets/photo_grid.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Widget reutilizable para grid de fotos con funcionalidad de toma/selección.
/// 
/// Permite agregar fotos desde cámara o galería, mostrarlas en grid y eliminarlas.
/// Ideal para formularios de reportes/incidencias.
/// 
/// Ejemplo de uso:
/// ```dart
/// PhotoGrid(
///   photos: _photos,
///   maxPhotos: 5,
///   onPhotosChanged: (newPhotos) => setState(() => _photos = newPhotos),
/// )
/// ```
class PhotoGrid extends StatelessWidget {
  /// Lista actual de fotos (como XFile o String URLs)
  final List<dynamic> photos;
  
  /// Callback cuando cambian las fotos
  final Function(List<dynamic>) onPhotosChanged;
  
  /// Máximo número de fotos permitidas
  final int maxPhotos;
  
  /// Si se permite usar la cámara
  final bool enableCamera;
  
  /// Si se permite seleccionar de galería
  final bool enableGallery;
  
  /// Mostrar metadatos de las fotos (GPS, fecha)
  final bool showMetadata;
  
  /// Columnas en el grid
  final int crossAxisCount;
  
  /// Espaciado entre fotos
  final double spacing;

  const PhotoGrid({
    super.key,
    required this.photos,
    required this.onPhotosChanged,
    this.maxPhotos = 5,
    this.enableCamera = true,
    this.enableGallery = true,
    this.showMetadata = true,
    this.crossAxisCount = 3,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final canAddMore = photos.length < maxPhotos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Botones de acción
        if (canAddMore) ...[
          Row(
            children: [
              if (enableCamera)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _takePicture(context),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Tomar Foto'),
                  ),
                ),
              if (enableCamera && enableGallery) const SizedBox(width: 8),
              if (enableGallery)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickFromGallery(context),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galería'),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        // Grid de fotos
        if (photos.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return _buildPhotoItem(context, photos[index], index);
            },
          ),

        // Contador de fotos
        if (photos.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '${photos.length}/$maxPhotos fotos',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildPhotoItem(BuildContext context, dynamic photo, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Imagen
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _buildImage(photo),
        ),

        // Botón eliminar
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removePhoto(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Badge de metadata (GPS/Hora)
        if (showMetadata && photo is XFile)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 12, color: Colors.greenAccent),
                  SizedBox(width: 4),
                  Text(
                    'GPS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImage(dynamic photo) {
    if (photo is XFile) {
      return Image.file(
        File(photo.path),
        fit: BoxFit.cover,
      );
    } else if (photo is String) {
      // URL de imagen
      if (photo.startsWith('http')) {
        return Image.network(
          photo,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      } else {
        // Path local
        return Image.file(
          File(photo),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      }
    }
    return const Icon(Icons.image);
  }

  Future<void> _takePicture(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (image != null) {
      final newPhotos = List<dynamic>.from(photos)..add(image);
      onPhotosChanged(newPhotos);
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (image != null) {
      final newPhotos = List<dynamic>.from(photos)..add(image);
      onPhotosChanged(newPhotos);
    }
  }

  void _removePhoto(int index) {
    final newPhotos = List<dynamic>.from(photos)..removeAt(index);
    onPhotosChanged(newPhotos);
  }
}
