// lib/src/features/incidents/presentation/screens/forms/create_incident_form_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/incident_entity.dart';
import '../../providers/incident_form_provider.dart';
import '../../utils/converters/incident_converters.dart';
import '../../utils/ui_helpers/ui_helpers.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

/// Screen 17: Formulario de Reporte Básico (Avance, Problema, Consulta, Seguridad)
/// 
/// REFACTORIZADO EN SEMANA 1:
/// - Usa FormFieldWithLabel para campos de texto
/// - Usa MultiImagePicker para fotos
/// - Usa FormActionButtons para submit
/// - Reducido de 256 → ~140 líneas (-45%)
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
  List<XFile> _images = [];
  bool _isCritical = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final incidentType = IncidentConverters.getIncidentTypeFromString(widget.type);
    final typeLabel = IncidentConverters.getTypeLabel(incidentType);
    final formProvider = context.watch<IncidentFormProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('$typeLabel - Nuevo Reporte'),
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
                backgroundColor: AppColors.withOpacity(_getTypeColor(), 0.15),
                child: Icon(
                  _getTypeIcon(),
                  size: 40,
                  color: _getTypeColor(),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Información general
            FormSection(
              title: 'Información General',
              isRequired: true,
              children: [
                FormFieldWithLabel(
                  label: 'Descripción',
                  hint: 'Describe el reporte en detalle...',
                  controller: _descriptionController,
                  validator: IncidentConverters.validateDescription,
                  maxLines: 5,
                  isRequired: true,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Evidencia fotográfica
            FormSection(
              title: 'Evidencia Fotográfica',
              subtitle: 'Adjunta hasta 5 fotos (opcional)',
              children: [
                MultiImagePicker(
                  images: _images,
                  maxImages: 5,
                  onImagesChanged: (images) => setState(() => _images = images),
                  emptyText: 'Agregar fotos del reporte',
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Prioridad
            FormSection(
              title: 'Prioridad',
              children: [
                SwitchListTile(
                  value: _isCritical,
                  onChanged: (value) => setState(() => _isCritical = value),
                  title: const Text('Marcar como Crítica'),
                  subtitle: const Text('Se notificará inmediatamente al equipo'),
                  secondary: Icon(
                    Icons.warning,
                    color: _isCritical ? AppColors.criticalStatusColor : AppColors.iconColor,
                  ),
                  tileColor: _isCritical ? AppColors.lighten(AppColors.criticalStatusColor, 0.95) : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _isCritical ? AppColors.criticalStatusColor : AppColors.borderColor,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Botón de envío
            FormActionButtons(
              submitText: 'Guardar Reporte',
              submitIcon: Icons.save,
              onSubmit: _submitIncident,
              isLoading: formProvider.isCreating,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitIncident() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.user;

    if (currentUser == null) {
      if (mounted) {
        UiHelpers.showErrorSnackBar(context, IncidentConverters.noAuthUserError);
      }
      return;
    }

    // Crear entidad de incidencia
    final incidentType = IncidentConverters.getIncidentTypeFromString(widget.type);
    final description = _descriptionController.text.trim();
    
    // Generar título automático basado en tipo y primeras palabras de descripción
    final titlePrefix = IncidentConverters.getTypeLabel(incidentType);
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

    // Llamar al provider para crear (usa handleFormSubmit helper)
    await UiHelpers.handleFormSubmit(
      context: context,
      operation: () => context.read<IncidentFormProvider>().createIncident(newIncident),
      successMessage: 'Reporte creado exitosamente',
      onSuccess: () => context.pop(true),
    );
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
        return AppColors.progressReportColor;
      case 'problema':
        return AppColors.problemColor;
      case 'consulta':
        return AppColors.consultationColor;
      case 'seguridad':
        return AppColors.safetyIncidentColor;
      default:
        return AppColors.iconColor;
    }
  }
}
