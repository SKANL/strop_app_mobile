import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incidents_provider.dart';

/// Screen 20: Registrar Aclaración (Modal)
/// 
/// Permite corregir un error sin violar la inalterabilidad (RF-C04).
/// Crea un nuevo registro en la bitácora vinculado al original.
/// 
/// Contenido:
/// - Referencia a la incidencia original
/// - Campo de explicación (obligatorio)
/// - Botón guardar
class CreateCorrectionScreen extends StatefulWidget {
  final String incidentId;

  const CreateCorrectionScreen({
    super.key,
    required this.incidentId,
  });

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Aclaración'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Banner informativo
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                border: Border.all(color: Colors.orange[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Las aclaraciones no modifican el reporte original. Se registran como eventos adicionales en la bitácora.',
                      style: TextStyle(
                        color: Colors.orange[900],
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
              'Aclaración para:',
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

            // Campo de explicación
            TextFormField(
              controller: _explanationController,
              decoration: const InputDecoration(
                labelText: 'Explicación *',
                hintText: 'Describe la corrección o aclaración necesaria...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit_note),
              ),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La explicación es obligatoria';
                }
                if (value.trim().length < 10) {
                  return 'La explicación debe tener al menos 10 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Ejemplos de uso
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Ejemplos de uso:',
                        style: TextStyle(
                          color: Colors.blue[900],
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
                        color: Colors.blue[800],
                        fontSize: 12,
                      ),
                    ),
                  )),
                ],
              ),
            ),
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
                    onPressed: _submitCorrection,
                    icon: const Icon(Icons.check),
                    label: const Text('Guardar Aclaración'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitCorrection() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final explanation = _explanationController.text.trim();
    
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    // Llamar al provider
    final incidentsProvider = context.read<IncidentsProvider>();
    final success = await incidentsProvider.addCorrection(widget.incidentId, explanation);

    if (!mounted) return;
    
    // Cerrar diálogo de loading
    Navigator.of(context).pop();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aclaración registrada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar: ${incidentsProvider.operationError ?? "Desconocido"}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
