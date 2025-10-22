// lib/src/features/incidents/presentation/screens/create_incident_form_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/manager/auth_provider.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../providers/incidents_provider.dart';

/// Screen 17: Formulario de Reporte Básico (Avance, Problema, Consulta, Seguridad)
class CreateIncidentFormScreen extends StatefulWidget {
  final String projectId;
  final String type;

  const CreateIncidentFormScreen({
    super.key,
    required this.projectId,
    required this.type,
  });

  @override
  State<CreateIncidentFormScreen> createState() => _CreateIncidentFormScreenState();
}

class _CreateIncidentFormScreenState extends State<CreateIncidentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isCritical = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_getTypeLabel()} - Nuevo Reporte'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // Icono del tipo
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: _getTypeColor().withValues(alpha: 0.15),
                child: Icon(
                  _getTypeIcon(),
                  size: 40,
                  color: _getTypeColor(),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Descripción
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción *',
                hintText: 'Describe el reporte en detalle...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripción es obligatoria';
                }
                if (value.trim().length < 10) {
                  return 'La descripción debe tener al menos 10 caracteres';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Sección de evidencia
            _buildEvidenceSection(context),
            
            const SizedBox(height: 24),
            
            // Toggle crítica
            SwitchListTile(
              value: _isCritical,
              onChanged: (value) {
                setState(() {
                  _isCritical = value;
                });
              },
              title: const Text('Marcar como Crítica'),
              subtitle: const Text('Se notificará inmediatamente al equipo'),
              secondary: Icon(
                Icons.warning,
                color: _isCritical ? Colors.red : Colors.grey,
              ),
              tileColor: _isCritical ? Colors.red[50] : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _isCritical ? Colors.red : Colors.grey[300]!,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Botón de envío
            _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitIncident,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 54),
                      backgroundColor: _getTypeColor(),
                    ),
                    child: const Text(
                      'Guardar Reporte',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.photo_camera, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Text(
              'Evidencia Fotográfica',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Text(
              '${_images.length}/5',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Botones de captura
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _images.length < 5 ? () => _pickImage(ImageSource.camera) : null,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tomar Foto'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _images.length < 5 ? () => _pickImage(ImageSource.gallery) : null,
                icon: const Icon(Icons.photo_library),
                label: const Text('Galería'),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Previsualización de imágenes
        if (_images.isEmpty)
          Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'No hay fotos adjuntas',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(_images[index].path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 16,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.red,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close, size: 16, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _images.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        
        const SizedBox(height: 8),
        
        // Nota informativa
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Las fotos tomadas con cámara incluyen GPS y marca de tiempo',
                  style: TextStyle(fontSize: 11, color: Colors.blue[900]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _images.add(pickedFile);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al capturar imagen: $e')),
        );
      }
    }
  }

  Future<void> _submitIncident() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.user;

    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No se encontró usuario autenticado')),
        );
      }
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Crear entidad de incidencia
    final incidentType = _getIncidentTypeFromString(widget.type);
    final description = _descriptionController.text.trim();
    
    // Generar título automático basado en tipo y primeras palabras de descripción
    final titlePrefix = _getTypeLabel().split('-').first.trim();
    final descWords = description.split(' ').take(5).join(' ');
    final autoTitle = '$titlePrefix: ${descWords.length > 30 ? '${descWords.substring(0, 30)}...' : descWords}';
    
    // Convertir XFile a rutas de string (en producción serían URLs después de subir)
    final photoUrls = _images.map((img) => img.path).toList();
    
    final newIncident = IncidentEntity(
      id: '', // El FakeDataSource asignará el ID
      projectId: widget.projectId,
      type: incidentType,
      title: autoTitle,
      description: description,
      createdBy: currentUser.name,
      createdAt: DateTime.now(),
      status: IncidentStatus.open,
      priority: _isCritical ? IncidentPriority.critical : IncidentPriority.normal,
      photoUrls: photoUrls,
    );

    // Llamar al provider para crear
    final incidentsProvider = context.read<IncidentsProvider>();
    final success = await incidentsProvider.createIncident(newIncident);

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reporte creado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop(true); // Retornar true para indicar éxito
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear reporte: ${incidentsProvider.operationError ?? "Desconocido"}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  IncidentType _getIncidentTypeFromString(String typeStr) {
    switch (typeStr.toLowerCase()) {
      case 'avance':
        return IncidentType.progressReport;
      case 'problema':
        return IncidentType.problem;
      case 'consulta':
        return IncidentType.consultation;
      case 'seguridad':
        return IncidentType.safetyIncident;
      case 'material':
        return IncidentType.materialRequest;
      default:
        return IncidentType.problem;
    }
  }

  String _getTypeLabel() {
    switch (widget.type.toLowerCase()) {
      case 'avance':
        return 'Reporte de Avance';
      case 'problema':
        return 'Problema / Falla';
      case 'consulta':
        return 'Consulta';
      case 'seguridad':
        return 'Incidente de Seguridad';
      default:
        return 'Nuevo Reporte';
    }
  }

  IconData _getTypeIcon() {
    switch (widget.type.toLowerCase()) {
      case 'avance':
        return Icons.trending_up;
      case 'problema':
        return Icons.error_outline;
      case 'consulta':
        return Icons.help_outline;
      case 'seguridad':
        return Icons.shield_outlined;
      default:
        return Icons.description;
    }
  }

  Color _getTypeColor() {
    switch (widget.type.toLowerCase()) {
      case 'avance':
        return Colors.blue;
      case 'problema':
        return Colors.orange;
      case 'consulta':
        return Colors.purple;
      case 'seguridad':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
