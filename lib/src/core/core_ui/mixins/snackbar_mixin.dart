// lib/src/core/core_ui/mixins/snackbar_mixin.dart
import 'package:flutter/material.dart';

/// Mixin para simplificar el uso de SnackBars en widgets.
///
/// Proporciona métodos helper para mostrar SnackBars de éxito, error e información.
///
/// **Uso**:
/// ```dart
/// class _MyScreenState extends State<MyScreen> with SnackBarMixin {
///   void _save() async {
///     try {
///       await repository.save();
///       showSuccessSnackBar('Guardado exitosamente');
///     } catch (e) {
///       showErrorSnackBar('Error al guardar');
///     }
///   }
/// }
/// ```
mixin SnackBarMixin<T extends StatefulWidget> on State<T> {
  /// Muestra un SnackBar de éxito (verde)
  void showSuccessSnackBar(String message, {Duration? duration}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Muestra un SnackBar de error (rojo)
  void showErrorSnackBar(String message, {Duration? duration}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: duration ?? const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Cerrar',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Muestra un SnackBar informativo (azul)
  void showInfoSnackBar(String message, {Duration? duration}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Muestra un SnackBar de advertencia (naranja)
  void showWarningSnackBar(String message, {Duration? duration}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Oculta el SnackBar actual
  void hideSnackBar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
