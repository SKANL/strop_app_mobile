// lib/src/core/core_ui/widgets/dialogs/confirm_dialog.dart
import 'package:flutter/material.dart';
import 'dialog_actions.dart';

/// Dialog reutilizable para confirmaciones.
///
/// Elimina código duplicado en ~10 lugares donde se muestra un dialog de confirmación.
/// Proporciona una interfaz consistente para confirmaciones en toda la app.
///
/// **Ejemplo básico**:
/// ```dart
/// final confirmed = await ConfirmDialog.show(
///   context: context,
///   title: 'Eliminar',
///   message: '¿Estás seguro?',
/// );
/// if (confirmed) {
///   _delete();
/// }
/// ```
///
/// **Con customización**:
/// ```dart
/// final result = await ConfirmDialog.show(
///   context: context,
///   title: 'Cerrar Incidencia',
///   message: 'Esta acción no se puede deshacer',
///   confirmText: 'Cerrar',
///   confirmIcon: Icons.check,
///   isDangerous: true,
/// );
/// ```
class ConfirmDialog extends StatelessWidget {
  /// Título del dialog
  final String title;

  /// Mensaje descriptivo
  final String message;

  /// Texto del botón de confirmación
  final String confirmText;

  /// Texto del botón de cancelación
  final String cancelText;

  /// Icono del botón de confirmación
  final IconData? confirmIcon;

  /// Si la acción es peligrosa (botón rojo)
  final bool isDangerous;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.confirmIcon,
    this.isDangerous = false,
  });

  /// Muestra el dialog y retorna true si se confirmó, false si se canceló
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    IconData? confirmIcon,
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmIcon: confirmIcon,
        isDangerous: isDangerous,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        isDangerous
            ? DialogActions.danger(
                onCancel: () => Navigator.of(context).pop(false),
                onConfirm: () => Navigator.of(context).pop(true),
                cancelText: cancelText,
                confirmText: confirmText,
              )
            : DialogActions(
                onCancel: () => Navigator.of(context).pop(false),
                onConfirm: () => Navigator.of(context).pop(true),
                cancelText: cancelText,
                confirmText: confirmText,
              ),
      ],
    );
  }
}
