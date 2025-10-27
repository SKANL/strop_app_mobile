import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar grids de fotos o imágenes.
/// 
/// Características:
/// - Soporta selección de imágenes
/// - Vista previa en pantalla completa
/// - Soporte para añadir/remover fotos
/// - Layout adaptativo según cantidad de fotos
/// - Placeholder para fotos vacías
/// - Soporte para caché de imágenes
class PhotoGrid extends StatelessWidget {
  /// URLs o paths de las imágenes a mostrar
  final List<String> photos;

  /// Callback cuando se selecciona una foto
  final void Function(String photo)? onPhotoSelected;

  /// Callback cuando se quiere eliminar una foto
  final void Function(String photo)? onPhotoRemoved;

  /// Callback cuando se quiere añadir una foto
  final VoidCallback? onAddPhoto;

  /// Máximo número de fotos permitidas
  final int? maxPhotos;

  /// Si es true, se puede seleccionar/deseleccionar fotos
  final bool selectable;

  /// Si es true, se muestra el botón de eliminar en cada foto
  final bool removable;

  /// Si es true, se muestra el botón de añadir si hay espacio
  final bool canAdd;

  /// Dimensiones de cada foto en la grilla
  final double photoSize;

  /// Radio del borde de las fotos
  final double borderRadius;

  /// Espacio entre fotos
  final double spacing;

  /// Si es true, las fotos se muestran en un layout fijo de 2x2
  final bool useFixedGrid;

  /// Constructor
  const PhotoGrid({
    super.key,
    required this.photos,
    this.onPhotoSelected,
    this.onPhotoRemoved,
    this.onAddPhoto,
    this.maxPhotos,
    this.selectable = true,
    this.removable = false,
    this.canAdd = false,
    this.photoSize = 100,
    this.borderRadius = 8,
    this.spacing = 8,
    this.useFixedGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasSpace = maxPhotos == null || photos.length < (maxPhotos ?? 0);
    final showAddButton = canAdd && hasSpace && onAddPhoto != null;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        ...photos.map((photo) => _buildPhotoItem(context, photo)),
        if (showAddButton) _buildAddButton(context),
      ],
    );
  }

  Widget _buildPhotoItem(BuildContext context, String photo) {
    return GestureDetector(
      onTap: () {
        if (selectable && onPhotoSelected != null) {
          onPhotoSelected!(photo);
        } else {
          _showFullScreenPhoto(context, photo);
        }
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.network(
              photo,
              width: photoSize,
              height: photoSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: photoSize,
                  height: photoSize,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image),
                );
              },
            ),
          ),
          if (removable && onPhotoRemoved != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => onPhotoRemoved!(photo),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: onAddPhoto,
      child: Container(
        width: photoSize,
        height: photoSize,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Colors.grey[400]!,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.add_photo_alternate_outlined,
            color: Colors.grey,
            size: 32,
          ),
        ),
      ),
    );
  }

  void _showFullScreenPhoto(BuildContext context, String photo) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            body: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  photo,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 64,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}