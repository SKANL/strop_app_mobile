// lib/features/incidents/presentation/widgets/image_gallery.dart
import 'package:flutter/material.dart';

class ImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  // Usamos un valor por defecto de 2 para el Grid, pero permitimos cambiarlo para móvil si es necesario.
  final int crossAxisCount;

  const ImageGallery({
    super.key,
    required this.imageUrls,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            'No hay imágenes adjuntas.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    // Para móvil, una sola columna puede ser mejor.
    if (crossAxisCount == 1) {
      return ListView.separated(
        itemCount: imageUrls.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) => _buildImage(imageUrls[index]),
      );
    }

    // Para web/tablet, usamos una cuadrícula.
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: imageUrls.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildImage(imageUrls[index]),
    );
  }

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network( // <-- Usando Image.network como en tu código
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
        },
      ),
    );
  }
}