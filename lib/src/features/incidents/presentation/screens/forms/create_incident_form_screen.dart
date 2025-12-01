// lib/src/features/incidents/presentation/screens/forms/create_incident_form_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/incident_entity.dart';
import '../../providers/incident_form_provider.dart';
import '../../utils/converters/incident_converters.dart';
import '../../utils/ui_helpers/ui_helpers.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';
import 'package:mobile_strop_app/src/core/core_ui/theme/app_colors.dart';

/// Screen 17: Formulario "Clean Mode" (Fase 7 UI/UX Overhaul)
///
/// FLUJO PASO A PASO:
/// 1. Evidencia (Fotos + Voz)
/// 2. Contexto (Ubicación/QR + Descripción)
/// 3. Revisión y Envío
class CreateIncidentFormScreen extends StatefulWidget {
  final String projectId;
  final String type;

  const CreateIncidentFormScreen({
    super.key,
    required this.projectId,
    required this.type,
  });

  @override
  State<CreateIncidentFormScreen> createState() =>
      _CreateIncidentFormScreenState();
}

class _CreateIncidentFormScreenState extends State<CreateIncidentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final PageController _pageController = PageController();

  // Estado del formulario
  List<XFile> _images = [];
  bool _isCritical = false;
  int _currentStep = 0;

  // Speech to Text
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onError: (e) => print('Speech error: $e'),
        onStatus: (s) => print('Speech status: $s'),
      );
      if (mounted) setState(() {});
    } catch (e) {
      print('Speech init failed: $e');
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _submitIncident();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  void _toggleListening() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reconocimiento de voz no disponible')),
      );
      return;
    }

    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _descriptionController.text = result.recognizedWords;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final incidentType = IncidentConverters.getIncidentTypeFromString(
      widget.type,
    );
    final typeLabel = IncidentConverters.getTypeLabel(incidentType);
    final typeColor = _getTypeColor();

    return Scaffold(
      appBar: AppBar(
        title: Text(typeLabel),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Paso ${_currentStep + 1}/3',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: AppColors.backgroundMedium,
            valueColor: AlwaysStoppedAnimation<Color>(typeColor),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Bloquear swipe manual
                children: [
                  _buildStep1Evidence(typeColor),
                  _buildStep2Context(typeColor),
                  _buildStep3Review(typeColor),
                ],
              ),
            ),
            _buildBottomBar(typeColor),
          ],
        ),
      ),
    );
  }

  // PASO 1: EVIDENCIA (FOTOS + VOZ)
  Widget _buildStep1Evidence(Color color) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          '¿Qué estás viendo?',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Agrega fotos y una descripción rápida.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),

        // Selector de Fotos
        MultiImagePicker(
          images: _images,
          maxImages: 5,
          onImagesChanged: (images) => setState(() => _images = images),
          emptyText: 'Toca para agregar fotos',
        ),

        const SizedBox(height: 32),

        // Descripción con Voz
        Row(
          children: [
            Expanded(
              child: Text(
                'Descripción',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            // Botón de Micrófono
            GestureDetector(
              onTap: _toggleListening,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isListening
                      ? AppColors.error
                      : color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isListening ? Icons.mic_off : Icons.mic,
                  color: _isListening ? Colors.white : color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: _isListening
                ? 'Escuchando...'
                : 'Escribe o dicta los detalles...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.backgroundLight,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor agrega una descripción';
            }
            return null;
          },
        ),
      ],
    );
  }

  // PASO 2: CONTEXTO (UBICACIÓN/QR + PRIORIDAD)
  Widget _buildStep2Context(Color color) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Detalles del Contexto',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),

        // Ubicación / QR
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: color),
                  const SizedBox(width: 8),
                  const Text(
                    'Ubicación',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Botón QR
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implementar Scanner Real
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Abriendo escáner QR...')),
                    );
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Escanear Código de Ubicación'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Prioridad
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isCritical
                ? AppColors.criticalStatusColor.withOpacity(0.1)
                : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: _isCritical
                ? Border.all(color: AppColors.criticalStatusColor)
                : null,
          ),
          child: SwitchListTile(
            value: _isCritical,
            onChanged: (value) => setState(() => _isCritical = value),
            title: Text(
              'Prioridad Crítica',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isCritical
                    ? AppColors.criticalStatusColor
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: const Text('Notificar inmediatamente al equipo'),
            secondary: Icon(
              Icons.warning_amber_rounded,
              color: _isCritical
                  ? AppColors.criticalStatusColor
                  : AppColors.iconColor,
              size: 32,
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  // PASO 3: REVISIÓN
  Widget _buildStep3Review(Color color) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 48, color: AppColors.successIcon),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '¿Todo listo?',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),

        // Resumen
        _buildReviewItem('Tipo', widget.type),
        _buildReviewItem('Descripción', _descriptionController.text),
        _buildReviewItem('Fotos', '${_images.length} adjuntas'),
        _buildReviewItem(
          'Prioridad',
          _isCritical ? 'CRÍTICA' : 'Normal',
          isCritical: _isCritical,
        ),
      ],
    );
  }

  Widget _buildReviewItem(
    String label,
    String value, {
    bool isCritical = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCritical
                    ? AppColors.criticalStatusColor
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            TextButton(onPressed: _prevStep, child: const Text('Atrás')),
          const Spacer(),
          ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(_currentStep == 2 ? 'ENVIAR REPORTE' : 'SIGUIENTE'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitIncident() async {
    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.user;

    if (currentUser == null) {
      UiHelpers.showErrorSnackBar(context, IncidentConverters.noAuthUserError);
      return;
    }

    final incidentType = IncidentConverters.getIncidentTypeFromString(
      widget.type,
    );
    final description = _descriptionController.text.trim();
    final titlePrefix = IncidentConverters.getTypeLabel(incidentType);
    final descWords = description.split(' ').take(5).join(' ');
    final autoTitle =
        '$titlePrefix: ${descWords.length > 30 ? '${descWords.substring(0, 30)}...' : descWords}';
    final photoUrls = _images.map((img) => img.path).toList();

    final newIncident = IncidentEntity(
      id: '',
      projectId: widget.projectId,
      type: incidentType,
      title: autoTitle,
      description: description,
      createdBy: currentUser.name,
      createdAt: DateTime.now(),
      status: IncidentStatus.open,
      priority: _isCritical
          ? IncidentPriority.critical
          : IncidentPriority.normal,
      photoUrls: photoUrls,
    );

    await UiHelpers.handleFormSubmit(
      context: context,
      operation: () =>
          context.read<IncidentFormProvider>().createIncident(newIncident),
      successMessage: 'Reporte creado exitosamente',
      onSuccess: () => context.pop(true),
    );
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
        return AppColors.primary;
    }
  }
}
