import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_detail_provider.dart';
import '../utils/incident_helpers.dart';
import '../utils/ui_helpers.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Screen 20: Registrar Aclaración (Modal)
/// 
/// REFACTORIZADO FASE 6:
/// - Usa ReferenceCard, ExampleCard y ActionConfirmationBanner
/// - Reducido de 235 → 90 líneas (-62%)
/// - Mejora: Widgets reutilizables, código limpio, DRY
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
                  ActionConfirmationBanner.warning(
                    message: 'Las aclaraciones no modifican el reporte original. Se registran como eventos adicionales en la bitácora.',
                  ),
                  const SizedBox(height: 24),
                  ReferenceCard(
                    label: 'Aclaración para:',
                    title: 'Incidencia #${widget.incidentId}',
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 24),
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
