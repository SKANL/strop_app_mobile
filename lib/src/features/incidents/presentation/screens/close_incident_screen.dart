import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Screen 22: Cerrar Incidencia (Modal)
/// 
/// Formaliza el cierre de una tarea (RF-B04).
/// Solo visible si eres el usuario asignado O un R/S superior.
/// 
/// Contenido:
/// - Nota de cierre (obligatorio)
/// - Adjuntar fotos de trabajo terminado (opcional)
/// - Botón confirmar cierre
class CloseIncidentScreen extends StatefulWidget {
  final String incidentId;

  const CloseIncidentScreen({
    super.key,
    required this.incidentId,
  });

  @override
  State<CloseIncidentScreen> createState() => _CloseIncidentScreenState();
}

class _CloseIncidentScreenState extends State<CloseIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _imagePicker = ImagePicker();
  final List<XFile> _selectedImages = [];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cerrar Incidencia'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Banner de confirmación
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border.all(color: Colors.green[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Al cerrar esta incidencia, se marcará como completada y se notificará al equipo.',
                      style: TextStyle(
                        color: Colors.green[900],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Referencia
            Text(
              'Cerrando:',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.description, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Incidencia #${widget.incidentId}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Campo de nota de cierre
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Nota de Cierre *',
                hintText: 'Describe cómo se resolvió la incidencia...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note_add),
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La nota de cierre es obligatoria';
                }
                if (value.trim().length < 10) {
                  return 'La nota debe tener al menos 10 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Sección de fotos (opcional)
            Text(
              'Evidencia de trabajo terminado (Opcional)',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.camera_alt, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Agrega fotos del trabajo completado para documentar el cierre',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Botones para agregar fotos
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectedImages.length < 5 ? _pickFromCamera : null,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Cámara'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectedImages.length < 5 ? _pickFromGallery : null,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galería'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Vista previa de fotos
            if (_selectedImages.isNotEmpty) _buildImagePreview(theme),
            const SizedBox(height: 32),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _closeIncident,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Confirmar Cierre'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fotos seleccionadas (${_selectedImages.length}/5)',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_selectedImages.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedImages.clear();
                  });
                },
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Limpiar todo'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedImages.map((image) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(image.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImages.remove(image);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
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
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _pickFromCamera() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  void _closeIncident() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // TODO: Implementar con Provider
    final note = _noteController.text.trim();
    print('Cerrando incidencia ${widget.incidentId}');
    print('Nota: $note');
    print('Fotos: ${_selectedImages.length}');

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Incidencia cerrada correctamente'),
        backgroundColor: Colors.green,
      ),
    );

    // Retornar a la pantalla anterior
    Navigator.of(context).pop(true);
  }
}
