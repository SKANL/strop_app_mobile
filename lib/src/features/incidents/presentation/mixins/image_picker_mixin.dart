// lib/src/features/incidents/presentation/mixins/image_picker_mixin.dart
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Mixin para consolidar lógica de selección de imágenes
/// 
/// Consolida lógica de selección de fotos común en:
/// - create_incident_form_screen.dart
/// - create_material_request_form_screen.dart
/// - create_correction_screen.dart
/// 
/// Reduce duplicación en ~60 líneas
mixin ImagePickerMixin {
  // ============================================================================
  // ESTADO - Imágenes
  // ============================================================================

  final List<XFile> selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  // ============================================================================
  // MÉTODOS - Seleccionar Imágenes
  // ============================================================================

  /// Seleccionar múltiples imágenes de la galería
  Future<void> pickImagesFromGallery({int maxImages = 10}) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        // Limitar cantidad de imágenes
        if (selectedImages.length + images.length > maxImages) {
          // Tomar solo las que caben
          final remaining = maxImages - selectedImages.length;
          selectedImages.addAll(images.take(remaining));
        } else {
          selectedImages.addAll(images);
        }
        onImagesSelected?.call();
      }
    } catch (e) {
      onImagePickError?.call('Error al seleccionar imágenes: ${e.toString()}');
    }
  }

  /// Tomar foto desde la cámara
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImages.add(image);
        onImagesSelected?.call();
      }
    } catch (e) {
      onImagePickError?.call('Error al tomar foto: ${e.toString()}');
    }
  }

  /// Mostrar diálogo de opciones para seleccionar fuente
  Future<void> showImageSourceDialog({
    String? cameraLabel,
    String? galleryLabel,
    String? cancelLabel,
  }) async {
    // Este método será implementado por la clase que usa el mixin
    // Es un placeholder para ser llamado desde la UI
  }

  // ============================================================================
  // MÉTODOS - Gestionar Imágenes Seleccionadas
  // ============================================================================

  /// Eliminar una imagen de la lista
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      onImagesChanged?.call();
    }
  }

  /// Eliminar todas las imágenes
  void clearAllImages() {
    selectedImages.clear();
    onImagesCleared?.call();
  }

  /// Obtener cantidad de imágenes seleccionadas
  int get imageCount => selectedImages.length;

  /// Verificar si hay imágenes seleccionadas
  bool get hasImages => selectedImages.isNotEmpty;

  /// Obtener la primera imagen (si existe)
  XFile? get firstImage => selectedImages.isNotEmpty ? selectedImages.first : null;

  /// Obtener lista de rutas de imágenes
  List<String> get imagePaths => selectedImages.map((img) => img.path).toList();

  // ============================================================================
  // CALLBACKS - Para que la clase que usa el mixin los implemente
  // ============================================================================

  /// Callback cuando se seleccionan imágenes
  VoidCallback? onImagesSelected;

  /// Callback cuando cambian las imágenes
  VoidCallback? onImagesChanged;

  /// Callback cuando se limpian las imágenes
  VoidCallback? onImagesCleared;

  /// Callback para errores
  Function(String error)? onImagePickError;
}
