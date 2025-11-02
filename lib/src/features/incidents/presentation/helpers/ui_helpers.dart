// lib/src/features/incidents/presentation/helpers/ui_helpers.dart

import 'package:flutter/material.dart';
import '../../../../core/core_ui/theme/app_colors.dart';

/// Utilidades compartidas para UI y feedback al usuario
/// Elimina duplicación de SnackBars, Dialogs y otros widgets de UI
class UiHelpers {
  UiHelpers._(); // Private constructor

  // ============================================================================
  // SnackBar Helpers
  // ============================================================================

  /// Muestra un SnackBar de éxito (verde)
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        duration: duration,
      ),
    );
  }

  /// Muestra un SnackBar de error (rojo)
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: duration,
      ),
    );
  }

  /// Muestra un SnackBar de información (azul)
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: duration,
      ),
    );
  }

  /// Muestra un SnackBar con color personalizado
  static void showCustomSnackBar(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }

  // ============================================================================
  // Loading Dialog Helpers
  // ============================================================================

  /// Muestra un diálogo de loading con mensaje
  static Future<void> showLoadingDialog(
    BuildContext context, {
    String message = 'Cargando...',
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }

  /// Cierra el diálogo de loading actual
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  // ============================================================================
  // Confirmation Dialog Helpers
  // ============================================================================

  /// Muestra un diálogo de confirmación (Sí/No)
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ============================================================================
  // Form Submission Helpers
  // ============================================================================

  /// Patrón reutilizable para manejo de submit con loading y feedback
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// await UiHelpers.handleFormSubmit(
  ///   context: context,
  ///   loadingMessage: 'Guardando...',
  ///   operation: () => provider.saveData(),
  ///   successMessage: 'Datos guardados correctamente',
  ///   errorMessage: 'Error al guardar',
  ///   onSuccess: () => Navigator.pop(context),
  /// );
  /// ```
  static Future<bool> handleFormSubmit({
    required BuildContext context,
    required Future<bool> Function() operation,
    String loadingMessage = 'Procesando...',
    String? successMessage,
    String? errorMessage,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    // Obtener referencias antes del async gap
    final messenger = ScaffoldMessenger.of(context);

    // Mostrar loading
    await showLoadingDialog(context, message: loadingMessage);

    // Ejecutar operación
    final success = await operation();

    // Cerrar loading
    if (context.mounted) {
      hideLoadingDialog(context);
    }

    // Mostrar resultado
    if (success) {
      if (successMessage != null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: AppColors.success,
          ),
        );
      }
      onSuccess?.call();
    } else {
      if (errorMessage != null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
          ),
        );
      }
      onError?.call();
    }

    return success;
  }

  // ============================================================================
  // Navigation Helpers
  // ============================================================================

  /// Navega a una ruta y espera resultado, manejando el mounted check
  static Future<T?> navigateTo<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) async {
    if (!context.mounted) return null;
    return await Navigator.of(context).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Navega y reemplaza la ruta actual
  static Future<T?> navigateAndReplace<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) async {
    if (!context.mounted) return null;
    return await Navigator.of(context).pushReplacementNamed<T, T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Vuelve atrás con un resultado, manejando el mounted check
  static void popWithResult<T>(BuildContext context, T result) {
    if (!context.mounted) return;
    Navigator.of(context).pop(result);
  }
}
