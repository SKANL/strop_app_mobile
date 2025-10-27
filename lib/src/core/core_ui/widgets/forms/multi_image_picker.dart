import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

/// Widget reutilizable para selección múltiple de imágenes
/// 
/// Elimina duplicación en 4 screens con imagen picker.
/// Incluye preview, eliminación individual, límite de imágenes.
/// 
/// Ejemplo de uso:
/// ```dart
/// MultiImagePicker(
///   images: _images,
///   maxImages: 5,
///   onImagesChanged: (images) => setState(() => _images = images),
///   emptyText: 'Agregar fotos del incidente',
/// )
/// ```
class MultiImagePicker extends StatelessWidget {
  const MultiImagePicker({
    super.key,
    required this.images,
    required this.onImagesChanged,
    this.maxImages = 5,
    this.emptyText = 'Agregar imágenes',
    this.gridCrossAxisCount = 3,
  });

  final List<XFile> images;
  final ValueChanged<List<XFile>> onImagesChanged;
  final int maxImages;
  final String emptyText;
  final int gridCrossAxisCount;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final remainingSlots = maxImages - images.length;
    
    if (remainingSlots <= 0) return;

    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isEmpty) return;

    final newImages = List<XFile>.from(images);
    final filesToAdd = pickedFiles.take(remainingSlots);
    newImages.addAll(filesToAdd);
    
    onImagesChanged(newImages);
  }

  void _removeImage(int index) {
    final newImages = List<XFile>.from(images);
    newImages.removeAt(index);
    onImagesChanged(newImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botón de agregar imágenes
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: images.length < maxImages ? _pickImages : null,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(
              images.isEmpty
                  ? emptyText
                  : '${images.length}/$maxImages imágenes seleccionadas',
            ),
          ),
        ),
        
        // Grid de imágenes
        if (images.isNotEmpty) ...[
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCrossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return _ImagePreviewCard(
                image: images[index],
                onRemove: () => _removeImage(index),
              );
            },
          ),
        ],
      ],
    );
  }
}

/// Card de preview para cada imagen
class _ImagePreviewCard extends StatelessWidget {
  const _ImagePreviewCard({
    required this.image,
    required this.onRemove,
  });

  final XFile image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Imagen
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(image.path),
            fit: BoxFit.cover,
          ),
        ),
        
        // Botón de eliminar
        Positioned(
          top: 4,
          right: 4,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onRemove,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
