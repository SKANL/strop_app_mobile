// lib/src/features/incidents/presentation/mixins/form_builder_mixin.dart
import 'package:flutter/material.dart';

/// Mixin para consolidar lógica de formularios
/// 
/// Consolida validaciones y manejo de estado comúnes en:
/// - create_incident_form_screen.dart
/// - create_material_request_form_screen.dart
/// - create_correction_screen.dart
/// - assign_user_screen.dart
/// - close_incident_screen.dart
/// 
/// Reduce duplicación en ~255 líneas
mixin FormBuilderMixin<T extends StatefulWidget> on State<T> {
  // ============================================================================
  // VALIDACIONES
  // ============================================================================

  /// Validar campo requerido
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  /// Validar email
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El email es requerido';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  /// Validar longitud mínima
  String? validateMinLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    if (value.length < length) {
      return '${fieldName ?? 'Este campo'} debe tener al menos $length caracteres';
    }
    return null;
  }

  /// Validar longitud máxima
  String? validateMaxLength(String? value, int length, {String? fieldName}) {
    if (value == null) return null;
    if (value.length > length) {
      return '${fieldName ?? 'Este campo'} no puede exceder $length caracteres';
    }
    return null;
  }

  /// Validar que dos campos coincidan
  String? validateFieldsMatch(String? value1, String? value2, String fieldName) {
    if (value1 != value2) {
      return 'Los $fieldName no coinciden';
    }
    return null;
  }

  /// Validar URL
  String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La URL es requerida';
    }
    final urlRegex = RegExp(r'^https?://');
    if (!urlRegex.hasMatch(value)) {
      return 'Ingresa una URL válida (https://...)';
    }
    return null;
  }

  /// Validar número
  String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    if (int.tryParse(value) == null && double.tryParse(value) == null) {
      return 'Ingresa un número válido';
    }
    return null;
  }

  // ============================================================================
  // UTILIDADES DE DIÁLOGOS
  // ============================================================================

  /// Mostrar diálogo de carga
  void showLoadingDialog({String message = 'Guardando...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  /// Cerrar diálogo de carga
  void dismissLoadingDialog() {
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  /// Mostrar diálogo de éxito
  Future<void> showSuccessDialog({
    required String title,
    required String message,
    String? buttonLabel,
    VoidCallback? onDismiss,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: Text(buttonLabel ?? 'Aceptar'),
          ),
        ],
      ),
    );
  }

  /// Mostrar diálogo de error
  Future<void> showErrorDialog({
    required String title,
    required String message,
    String? buttonLabel,
    VoidCallback? onDismiss,
  }) async {
    await showDialog(
      context: context,
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
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: Text(buttonLabel ?? 'Aceptar'),
          ),
        ],
      ),
    );
  }

  /// Mostrar diálogo de confirmación
  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel ?? 'Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel ?? 'Aceptar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ============================================================================
  // UTILIDADES DE SNACKBAR
  // ============================================================================

  /// Mostrar Snackbar de éxito
  void showSuccessSnackbar(String message) {
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Mostrar Snackbar de error
  void showErrorSnackbar(String message) {
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
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Mostrar Snackbar de advertencia
  void showWarningSnackbar(String message) {
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Mostrar Snackbar de información
  void showInfoSnackbar(String message) {
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ============================================================================
  // UTILIDADES DE NAVEGACIÓN
  // ============================================================================

  /// Desplazarse hacia arriba en ScrollController
  void scrollToTop(ScrollController? controller) {
    if (controller != null && controller.hasClients) {
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Desplazarse hacia abajo
  void scrollToBottom(ScrollController? controller) {
    if (controller != null && controller.hasClients) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // ============================================================================
  // UTILIDADES DE FOCUS
  // ============================================================================

  /// Quitar foco del campo actual
  void dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  /// Enfocar un campo específico
  void focusNode(FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }
}
