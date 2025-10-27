import 'package:flutter/material.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/buttons/app_button.dart';

/// Widget reutilizable para botones de acción en diálogos.
/// 
/// Proporciona un layout consistente con botones alineados correctamente:
/// - Botón de cancelar (secundario o text) a la izquierda
/// - Botón de confirmar (primary o danger) a la derecha
/// - Espaciado y padding automáticos
/// 
/// Ejemplo de uso:
/// ```dart
/// // Diálogo de confirmación estándar
/// AlertDialog(
///   title: Text('Confirmar'),
///   content: Text('¿Estás seguro?'),
///   actions: [
///     DialogActions(
///       onCancel: () => Navigator.pop(context),
///       onConfirm: () => deleteItem(),
///       confirmText: 'Eliminar',
///     ),
///   ],
/// )
/// 
/// // Diálogo con botón de peligro
/// AlertDialog(
///   title: Text('Eliminar proyecto'),
///   content: Text('Esta acción no se puede deshacer'),
///   actions: [
///     DialogActions.danger(
///       onCancel: () => Navigator.pop(context),
///       onConfirm: () => deleteProject(),
///       confirmText: 'Eliminar',
///     ),
///   ],
/// )
/// 
/// // Diálogo con loading
/// AlertDialog(
///   title: Text('Guardar cambios'),
///   content: Text('¿Deseas guardar los cambios?'),
///   actions: [
///     DialogActions(
///       onCancel: () => Navigator.pop(context),
///       onConfirm: () => save(),
///       isLoading: isSaving,
///       confirmText: 'Guardar',
///     ),
///   ],
/// )
/// 
/// // Diálogo solo con botón de confirmar
/// AlertDialog(
///   title: Text('Información'),
///   content: Text('Operación completada exitosamente'),
///   actions: [
///     DialogActions(
///       onConfirm: () => Navigator.pop(context),
///       confirmText: 'Aceptar',
///       showCancelButton: false,
///     ),
///   ],
/// )
/// ```
class DialogActions extends StatelessWidget {
  const DialogActions({
    super.key,
    this.onCancel,
    required this.onConfirm,
    this.cancelText = 'Cancelar',
    this.confirmText = 'Confirmar',
    this.isLoading = false,
    this.showCancelButton = true,
    this.confirmButtonType = _ConfirmButtonType.primary,
  });

  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final String cancelText;
  final String confirmText;
  final bool isLoading;
  final bool showCancelButton;
  final _ConfirmButtonType confirmButtonType;

  /// Constructor para diálogos con acción de peligro (botón rojo).
  const DialogActions.danger({
    super.key,
    this.onCancel,
    required this.onConfirm,
    this.cancelText = 'Cancelar',
    this.confirmText = 'Eliminar',
    this.isLoading = false,
    this.showCancelButton = true,
  }) : confirmButtonType = _ConfirmButtonType.danger;

  /// Constructor para diálogos de éxito (botón verde).
  const DialogActions.success({
    super.key,
    this.onCancel,
    required this.onConfirm,
    this.cancelText = 'Cancelar',
    this.confirmText = 'Aceptar',
    this.isLoading = false,
    this.showCancelButton = true,
  }) : confirmButtonType = _ConfirmButtonType.success;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showCancelButton) ...[
            Expanded(
              child: AppButton.text(
                text: cancelText,
                onPressed: onCancel,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: showCancelButton ? 1 : 2,
            child: _buildConfirmButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    switch (confirmButtonType) {
      case _ConfirmButtonType.primary:
        return AppButton.primary(
          text: confirmText,
          isLoading: isLoading,
          onPressed: onConfirm,
        );
      case _ConfirmButtonType.danger:
        return AppButton.danger(
          text: confirmText,
          isLoading: isLoading,
          onPressed: onConfirm,
        );
      case _ConfirmButtonType.success:
        return AppButton.success(
          text: confirmText,
          isLoading: isLoading,
          onPressed: onConfirm,
        );
    }
  }
}

enum _ConfirmButtonType {
  primary,
  danger,
  success,
}
