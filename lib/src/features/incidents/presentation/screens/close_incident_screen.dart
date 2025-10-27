import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_form_provider.dart';
import '../utils/incident_helpers.dart';
import '../utils/ui_helpers.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Screen 22: Cerrar Incidencia (Modal)
/// 
/// Formaliza el cierre de una tarea (RF-B04).
/// Solo visible si eres el usuario asignado O un R/S superior.
/// 
/// REFACTORIZADO EN SEMANA 3:
/// - Usa FormFieldWithLabel y FormActionButtons
/// - Reducido de 193 → ~115 líneas (-40%)
/// - Eliminado código de UI duplicado
/// - Mantiene FormSection + PhotoGrid
class CloseIncidentScreen extends StatefulWidget {
  const CloseIncidentScreen({
    super.key,
    required this.incidentId,
  });

  final String incidentId;

  @override
  State<CloseIncidentScreen> createState() => _CloseIncidentScreenState();
}

class _CloseIncidentScreenState extends State<CloseIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  List<dynamic> _selectedImages = [];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formProvider = context.watch<IncidentFormProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cerrar Incidencia'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildConfirmationBanner(),
                  const SizedBox(height: 24),
                  _buildReferenceCard(theme),
                  const SizedBox(height: 24),
                  FormFieldWithLabel(
                    label: 'Nota de Cierre',
                    controller: _noteController,
                    hint: 'Describe cómo se resolvió la incidencia...',
                    prefixIcon: const Icon(Icons.note_add),
                    maxLines: 4,
                    isRequired: true,
                    validator: IncidentHelpers.validateCloseNote,
                  ),
                  const SizedBox(height: 24),
                  FormSection(
                    title: 'Evidencia de trabajo terminado',
                    subtitle: 'Agrega fotos del trabajo completado (opcional)',
                    children: [
                      PhotoGrid(
                        photos: _selectedImages,
                        onPhotosChanged: (photos) {
                          setState(() {
                            _selectedImages = photos;
                          });
                        },
                        maxPhotos: 5,
                        showMetadata: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildActionButtons(formProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Al cerrar esta incidencia, se marcará como completada y se notificará al equipo.',
              style: TextStyle(
                color: Colors.green.shade900,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceCard(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cerrando:', style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.description, color: Colors.grey.shade600),
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
      ],
    );
  }

  Widget _buildActionButtons(IncidentFormProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: FormActionButtons(
          submitText: 'Confirmar Cierre',
          onSubmit: () => _handleClose(provider),
          isLoading: provider.isCreating, // Reutilizando flag del provider
        ),
      ),
    );
  }

  Future<void> _handleClose(IncidentFormProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final note = _noteController.text.trim();

    await UiHelpers.handleFormSubmit(
      context: context,
      loadingMessage: 'Cerrando incidencia...',
      operation: () => provider.closeIncident(widget.incidentId, note),
      successMessage: 'Incidencia cerrada correctamente',
      onSuccess: () => Navigator.of(context).pop(true),
    );
  }
}
