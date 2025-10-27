// lib/src/core/core_ui/extensions/build_context_extensions.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/dialogs/confirm_dialog.dart';

/// Extensions útiles para BuildContext.
///
/// Proporciona métodos helper para navegación, dialogs y SnackBars.
extension BuildContextX on BuildContext {
  // ==========================================================================
  // NAVEGACIÓN
  // ==========================================================================

  /// Navega a una ruta
  void navigateTo(String route, {Object? extra}) {
    push(route, extra: extra);
  }

  /// Navega a una ruta reemplazando la actual
  void navigateToReplacement(String route, {Object? extra}) {
    pushReplacement(route, extra: extra);
  }

  /// Vuelve atrás en la navegación
  void navigateBack([Object? result]) {
    pop(result);
  }

  /// Verifica si puede hacer pop
  bool get canPop => GoRouter.of(this).canPop();

  // ==========================================================================
  // DIALOGS
  // ==========================================================================

  /// Muestra un dialog de confirmación
  /// Retorna true si se confirmó, false si se canceló
  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    bool isDangerous = false,
  }) async {
    return await ConfirmDialog.show(
      context: this,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      isDangerous: isDangerous,
    );
  }

  /// Muestra un dialog de información
  Future<void> showInfoDialog({
    required String title,
    required String message,
    String buttonText = 'Aceptar',
  }) async {
    await showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Muestra un dialog de error
  Future<void> showErrorDialog({
    String title = 'Error',
    required String message,
    String buttonText = 'Cerrar',
  }) async {
    await showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SNACKBARS
  // ==========================================================================

  /// Muestra un SnackBar de éxito
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Muestra un SnackBar de error
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Muestra un SnackBar informativo
  void showInfoSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================================
  // TEMA Y ESTILOS
  // ==========================================================================

  /// Acceso rápido al ThemeData
  ThemeData get theme => Theme.of(this);

  /// Acceso rápido al TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Acceso rápido al ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Acceso rápido a MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Ancho de la pantalla
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Alto de la pantalla
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Si es un dispositivo pequeño (< 600px)
  bool get isSmallScreen => MediaQuery.of(this).size.width < 600;

  /// Si es un dispositivo mediano (600-1200px)
  bool get isMediumScreen {
    final width = MediaQuery.of(this).size.width;
    return width >= 600 && width < 1200;
  }

  /// Si es un dispositivo grande (>= 1200px)
  bool get isLargeScreen => MediaQuery.of(this).size.width >= 1200;

  // ==========================================================================
  // KEYBOARD
  // ==========================================================================

  /// Oculta el teclado
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Si el teclado está visible
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;
}
