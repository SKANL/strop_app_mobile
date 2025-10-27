// lib/src/features/incidents/presentation/screens/create_material_request_form_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/manager/auth_provider.dart';
import '../utils/ui_helpers.dart';
import '../utils/incident_helpers.dart';
import '../../../../core/core_ui/widgets/widgets.dart';
import '../widgets/material_search_selector.dart';
import '../widgets/quantity_input_section.dart';
import '../widgets/urgent_toggle_section.dart';

/// Screen 18: Formulario de Solicitud de Material (solo Residentes/Superintendentes)
/// 
/// REFACTORIZADO EN SEMANA 1:
/// - Usa FormFieldWithLabel para campos de texto
/// - Usa MultiImagePicker para evidencias fotográficas
/// - Usa FormActionButtons para submit
/// - Eliminado ImagePicker manual y gestión de imágenes
/// - Reducido de 283 → ~165 líneas (-42%)
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
  
  List<XFile> _images = [];
  
  bool _isCritical = false;
  
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
        backgroundColor: AppColors.materialRequestColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // Banner de advertencia
            CriticalBanner(
              message: 'Requiere Aprobación del Dueño\n\nEsta solicitud será revisada antes de ser aprobada o rechazada.',
              type: CriticalBannerType.warning,
              showIcon: true,
            ),
            
            const SizedBox(height: 24),
            
            // Búsqueda de insumo
            MaterialSearchSelector(
              searchController: _searchController,
              filteredMaterials: _filteredMaterials,
              selectedMaterial: _selectedMaterial,
              selectedUnit: _selectedUnit,
              onMaterialSelected: (material, unit) {
                setState(() {
                  _selectedMaterial = material;
                  _selectedUnit = unit;
                  _searchController.text = material;
                });
              },
              onClearSearch: () {
                _searchController.clear();
              },
            ),
            
            const SizedBox(height: 24),
            
            // Cantidad y unidad
            QuantityInputSection(
              quantityController: _quantityController,
              selectedUnit: _selectedUnit,
            ),
            
            const SizedBox(height: 24),
            
            // Descripción
            FormFieldWithLabel(
              label: 'Descripción / Especificaciones',
              hint: 'Detalles adicionales sobre el material...',
              controller: _descriptionController,
              maxLines: 3,
            ),
            
            const SizedBox(height: 24),
            
            // Justificación (OBLIGATORIO)
            FormFieldWithLabel(
              label: 'Justificación',
              hint: '¿Por qué se necesita este material?',
              controller: _justificationController,
              maxLines: 4,
              isRequired: true,
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
            FormSection(
              title: 'Evidencia Fotográfica',
              subtitle: 'Adjunta fotos del área o necesidad',
              children: [
                MultiImagePicker(
                  images: _images,
                  maxImages: 5,
                  onImagesChanged: (images) => setState(() => _images = images),
                  emptyText: 'Agregar evidencias',
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Toggle crítica
            UrgentToggleSection(
              isCritical: _isCritical,
              onChanged: (value) {
                setState(() {
                  _isCritical = value;
                });
              },
            ),
            
            const SizedBox(height: 32),
            
            // Botón de envío
            FormActionButtons(
              submitText: 'Enviar Solicitud',
              submitIcon: Icons.send,
              onSubmit: _submitMaterialRequest,
              isLoading: false, // TODO: Integrar con provider cuando exista
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitMaterialRequest() async {
    if (_selectedMaterial == null) {
      UiHelpers.showInfoSnackBar(context, 'Selecciona un insumo de la lista');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.user;

    if (currentUser == null) {
      UiHelpers.showErrorSnackBar(context, IncidentHelpers.noAuthUserError);
      return;
    }

    // TODO: Implementar envío con Provider real
    // Simular envío por ahora
    await UiHelpers.handleFormSubmit(
      context: context,
      operation: () async {
        // La API debe comparar con la Explosión de Insumos
        await Future.delayed(const Duration(seconds: 2));
        return true;
      },
      successMessage: 'Solicitud enviada - En espera de aprobación',
      onSuccess: () => context.pop(),
    );
  }
}
