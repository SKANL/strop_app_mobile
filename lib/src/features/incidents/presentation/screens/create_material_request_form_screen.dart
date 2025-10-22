// lib/src/features/incidents/presentation/screens/create_material_request_form_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/manager/auth_provider.dart';

/// Screen 18: Formulario de Solicitud de Material (solo Residentes/Superintendentes)
class CreateMaterialRequestFormScreen extends StatefulWidget {
  final String projectId;

  const CreateMaterialRequestFormScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<CreateMaterialRequestFormScreen> createState() =>
      _CreateMaterialRequestFormScreenState();
}

class _CreateMaterialRequestFormScreenState
    extends State<CreateMaterialRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _justificationController = TextEditingController();
  final _quantityController = TextEditingController();
  final _searchController = TextEditingController();
  
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  
  bool _isCritical = false;
  bool _isSubmitting = false;
  
  String? _selectedMaterial;
  String? _selectedUnit;
  
  // Lista de ejemplo de insumos (TODO: obtener de base de datos)
  final List<Map<String, String>> _availableMaterials = [
    {'name': 'Cemento Portland', 'unit': 'bultos'},
    {'name': 'Arena', 'unit': 'm³'},
    {'name': 'Grava', 'unit': 'm³'},
    {'name': 'Varilla 3/8"', 'unit': 'kg'},
    {'name': 'Varilla 1/2"', 'unit': 'kg'},
    {'name': 'Tubería PVC 4"', 'unit': 'mts'},
    {'name': 'Cable calibre 12', 'unit': 'mts'},
    {'name': 'Ladrillo rojo', 'unit': 'millares'},
    {'name': 'Block 15x20x40', 'unit': 'piezas'},
  ];

  List<Map<String, String>> _filteredMaterials = [];

  @override
  void initState() {
    super.initState();
    _filteredMaterials = _availableMaterials;
    _searchController.addListener(_filterMaterials);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _justificationController.dispose();
    _quantityController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterMaterials() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredMaterials = _availableMaterials;
      } else {
        _filteredMaterials = _availableMaterials
            .where((material) =>
                material['name']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud de Material'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // Banner de advertencia
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber[700]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.admin_panel_settings, color: Colors.amber[900], size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requiere Aprobación del Dueño',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[900],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Esta solicitud será revisada antes de ser aprobada o rechazada.',
                          style: TextStyle(fontSize: 12, color: Colors.amber[900]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Búsqueda de insumo
            Text(
              'Insumo Solicitado *',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar insumo...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Lista de resultados
            if (_searchController.text.isNotEmpty && _filteredMaterials.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredMaterials.length,
                  itemBuilder: (context, index) {
                    final material = _filteredMaterials[index];
                    return ListTile(
                      title: Text(material['name']!),
                      subtitle: Text('Unidad: ${material['unit']}'),
                      trailing: _selectedMaterial == material['name']
                          ? const Icon(Icons.check_circle, color: Colors.teal)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedMaterial = material['name'];
                          _selectedUnit = material['unit'];
                          _searchController.text = material['name']!;
                        });
                      },
                    );
                  },
                ),
              ),
            
            if (_selectedMaterial != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.teal, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Seleccionado: $_selectedMaterial',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Cantidad y unidad
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa la cantidad';
                      }
                      final number = double.tryParse(value);
                      if (number == null || number <= 0) {
                        return 'Cantidad inválida';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: _selectedUnit ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Unidad',
                      border: OutlineInputBorder(),
                    ),
                    enabled: false,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Descripción
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción / Especificaciones',
                hintText: 'Detalles adicionales sobre el material...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 24),
            
            // Justificación (OBLIGATORIO)
            TextFormField(
              controller: _justificationController,
              decoration: const InputDecoration(
                labelText: 'Justificación *',
                hintText: '¿Por qué se necesita este material?',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La justificación es obligatoria';
                }
                if (value.trim().length < 20) {
                  return 'La justificación debe tener al menos 20 caracteres';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Evidencia fotográfica
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
              title: const Text('Marcar como Urgente'),
              subtitle: const Text('Se priorizará la revisión'),
              secondary: Icon(
                Icons.priority_high,
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
                    onPressed: _submitMaterialRequest,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 54),
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text(
                      'Enviar Solicitud',
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
            const Icon(Icons.photo_camera, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Evidencia Fotográfica (Opcional)',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Text(
              '${_images.length}/5',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _images.length < 5 ? () => _pickImage(ImageSource.camera) : null,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Cámara'),
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
        
        if (_images.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
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
                          image: FileImage(File(_images[index].path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 12,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.red,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close, size: 14, color: Colors.white),
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
        ],
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

  Future<void> _submitMaterialRequest() async {
    if (_selectedMaterial == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un insumo de la lista')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.user;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se encontró usuario autenticado')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // TODO: Implementar envío con Provider
    // La API debe comparar con la Explosión de Insumos
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud enviada - En espera de aprobación'),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 3),
        ),
      );

      context.pop();
    }
  }
}
