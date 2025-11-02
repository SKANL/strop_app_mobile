import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/incident_detail_provider.dart';
import '../../helpers/incident_helpers.dart';
import '../../helpers/ui_helpers.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Screen 20: Registrar Aclaración (Modal)
/// 
/// Permite corregir un error sin violar la inalterabilidad (RF-C04).
/// Crea un nuevo registro en la bitácora vinculado al original.
/// 
/// REFACTORIZADO EN SEMANA 3:
/// - Usa FormFieldWithLabel y FormActionButtons
/// - Reducido de 235 → ~130 líneas (-45%)
/// - Eliminado código de UI duplicado
/// - Usa UiHelpers.handleFormSubmit
///
/// REFACTORIZADO EN FASE 6 (Nueva):
/// - Usa ReferenceCard y ExampleCard para eliminar más duplicación
/// - Usa ActionConfirmationBanner para el banner informativo
/// - Reducido a ~90 líneas (-65% del original)
class CreateCorrectionScreen extends StatefulWidget {
  const CreateCorrectionScreen({
    super.key,
    required this.incidentId,
  });

  final String incidentId;

  @override
  State<CreateCorrectionScreen> createState() => _CreateCorrectionScreenState();
}

class _CreateCorrectionScreenState extends State<CreateCorrectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _explanationController = TextEditingController();

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailProvider = context.watch<IncidentDetailProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Aclaración'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Banner informativo reutilizable
                  ActionConfirmationBanner.warning(
                    message: 'Las aclaraciones no modifican el reporte original. Se registran como eventos adicionales en la bitácora.',
                  ),
                  const SizedBox(height: 24),
                  
                  // Reference card reutilizable
                  ReferenceCard(
                    label: 'Aclaración para:',
                    title: 'Incidencia #${widget.incidentId}',
                    icon: Icons.description,
                    backgroundColor: Colors.grey.shade100,
                  ),
                  const SizedBox(height: 24),
                  
                  // Campo de texto reutilizable
                  FormFieldWithLabel(
                    label: 'Explicación',
                    controller: _explanationController,
                    hint: 'Describe la corrección o aclaración necesaria...',
                    prefixIcon: const Icon(Icons.edit_note),
                    maxLines: 5,
                    isRequired: true,
                    validator: IncidentHelpers.validateExplanation,
                  ),
                  const SizedBox(height: 24),
                  
                  // Example card reutilizable
                  ExampleCard(
                    title: 'Ejemplos de uso:',
                    examples: const [
                      '• Corrección de ubicación o datos',
                      '• Actualización de cantidades',
                      '• Información adicional importante',
                      '• Aclaraciones sobre el contexto',
                    ],
                  ),
                ],
              ),
            ),
            _buildActionButtons(detailProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(IncidentDetailProvider provider) {
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
          submitText: 'Guardar Aclaración',
          onSubmit: () => _handleSubmit(provider),
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(IncidentDetailProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final explanation = _explanationController.text.trim();

    await UiHelpers.handleFormSubmit(
      context: context,
      loadingMessage: 'Guardando aclaración...',
      operation: () => provider.addCorrection(widget.incidentId, explanation),
      successMessage: 'Aclaración registrada correctamente',
      onSuccess: () => Navigator.of(context).pop(true),
    );
  }
}
