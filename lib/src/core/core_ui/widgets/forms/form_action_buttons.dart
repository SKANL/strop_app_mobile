import 'package:flutter/material.dart';

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
