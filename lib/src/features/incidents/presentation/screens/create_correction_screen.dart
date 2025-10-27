import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_detail_provider.dart';
import '../utils/incident_helpers.dart';
import '../utils/ui_helpers.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

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
    final theme = Theme.of(context);
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
                  _buildInfoBanner(),
                  const SizedBox(height: 24),
                  _buildReferenceCard(theme),
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
                  _buildExamplesCard(),
                ],
              ),
            ),
            _buildActionButtons(detailProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Las aclaraciones no modifican el reporte original. Se registran como eventos adicionales en la bitácora.',
              style: TextStyle(
                color: Colors.orange.shade900,
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
        Text('Aclaración para:', style: theme.textTheme.labelLarge),
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

  Widget _buildExamplesCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Ejemplos de uso:',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...const [
            '• Corrección de ubicación o datos',
            '• Actualización de cantidades',
            '• Información adicional importante',
            '• Aclaraciones sobre el contexto',
          ].map((text) => Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 12,
              ),
            ),
          )),
        ],
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
          isLoading: provider.isAddingComment, // Reutilizando flag del provider
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
