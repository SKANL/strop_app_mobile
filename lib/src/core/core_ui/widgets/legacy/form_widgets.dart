import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget reutilizable para campos de formulario con label consistente
/// 
/// Elimina duplicación en 8+ screens de formularios.
/// Proporciona estilo y comportamiento consistente para todos los campos.
/// 
/// Ejemplo de uso:
/// ```dart
/// FormFieldWithLabel(
///   label: 'Descripción',
///   hint: 'Describe el reporte...',
///   controller: _descriptionController,
///   validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
///   maxLines: 5,
/// )
/// ```
class FormFieldWithLabel extends StatelessWidget {
  const FormFieldWithLabel({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    this.isRequired = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool isRequired;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label con indicador de requerido
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                text: label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
          ),
        
        // Campo de texto
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            enabled: enabled,
            alignLabelWithHint: maxLines > 1,
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Widget reutilizable para botones de acción de formulario
/// 
/// Elimina duplicación en 6+ screens con botones submit/cancel.
/// Maneja estados de loading automáticamente.
/// 
/// Ejemplo de uso:
/// ```dart
/// FormActionButtons(
///   submitText: 'Guardar',
///   onSubmit: _handleSubmit,
///   isLoading: provider.isSubmitting,
///   onCancel: () => Navigator.pop(context),
/// )
/// ```
class FormActionButtons extends StatelessWidget {
  const FormActionButtons({
    super.key,
    required this.onSubmit,
    this.onCancel,
    this.submitText = 'Guardar',
    this.cancelText = 'Cancelar',
    this.isLoading = false,
    this.submitIcon,
  });

  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final String submitText;
  final String cancelText;
  final bool isLoading;
  final IconData? submitIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // Botón cancelar (si existe)
          if (onCancel != null) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading ? null : onCancel,
                child: Text(cancelText),
              ),
            ),
            const SizedBox(width: 16),
          ],
          
          // Botón submit
          Expanded(
            flex: onCancel != null ? 1 : 1,
            child: ElevatedButton(
              onPressed: isLoading || onSubmit == null ? null : onSubmit,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (submitIcon != null) ...[
                          Icon(submitIcon, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(submitText),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
