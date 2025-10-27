import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

/// Widget reutilizable para campos de formulario con label consistente
/// 
/// Elimina duplicación en 8+ screens de formularios.
/// Proporciona estilo y comportamiento consistente para todos los campos.
/// 
/// Ejemplo de uso:
/// ```dart
/// FormFieldWithLabel(
///   label: 'Descripción',
///   hint: 'Describe el reporte...',
///   controller: _descriptionController,
///   validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
///   maxLines: 5,
/// )
/// ```
class FormFieldWithLabel extends StatelessWidget {
  const FormFieldWithLabel({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    this.isRequired = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool isRequired;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label con indicador de requerido
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                text: label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
          ),
        
        // Campo de texto
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            enabled: enabled,
            alignLabelWithHint: maxLines > 1,
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

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

/// Widget reutilizable para botones de acción de formulario
/// 
/// Elimina duplicación en 6+ screens con botones submit/cancel.
/// Maneja estados de loading automáticamente.
/// 
/// Ejemplo de uso:
/// ```dart
/// FormActionButtons(
///   submitText: 'Guardar',
///   onSubmit: _handleSubmit,
///   isLoading: provider.isSubmitting,
///   onCancel: () => Navigator.pop(context),
/// )
/// ```
class FormActionButtons extends StatelessWidget {
  const FormActionButtons({
    super.key,
    required this.onSubmit,
    this.onCancel,
    this.submitText = 'Guardar',
    this.cancelText = 'Cancelar',
    this.isLoading = false,
    this.submitIcon,
  });

  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final String submitText;
  final String cancelText;
  final bool isLoading;
  final IconData? submitIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // Botón cancelar (si existe)
          if (onCancel != null) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : onCancel,
                child: Text(cancelText),
              ),
            ),
            const SizedBox(width: 16),
          ],
          
          // Botón submit
          Expanded(
            flex: onCancel != null ? 1 : 1,
            child: ElevatedButton(
              onPressed: isLoading || onSubmit == null ? null : onSubmit,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (submitIcon != null) ...[
                          Icon(submitIcon, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(submitText),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
