// lib/src/core/core_ui/mixins/form_mixin.dart
import 'package:flutter/material.dart';

/// Mixin para simplificar el manejo de formularios en StatefulWidgets.
///
/// Proporciona métodos helper comunes para validación y gestión de formularios.
///
/// **Uso**:
/// ```dart
/// class _MyFormState extends State<MyForm> with FormMixin {
///   @override
///   Widget build(BuildContext context) {
///     return Form(
///       key: formKey, // Proporcionado por el mixin
///       child: Column(
///         children: [
///           TextFormField(...),
///           ElevatedButton(
///             onPressed: () {
///               if (validateForm()) { // Método del mixin
///                 // Enviar formulario
///               }
///             },
///             child: const Text('Enviar'),
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
mixin FormMixin<T extends StatefulWidget> on State<T> {
  /// Key global del formulario
  final formKey = GlobalKey<FormState>();

  /// Valida el formulario
  /// Retorna true si es válido, false si no
  bool validateForm() {
    final currentState = formKey.currentState;
    if (currentState == null) return false;
    return currentState.validate();
  }

  /// Valida y guarda el formulario
  /// Retorna true si es válido y se guardó, false si no
  bool validateAndSave() {
    final currentState = formKey.currentState;
    if (currentState == null) return false;

    if (currentState.validate()) {
      currentState.save();
      return true;
    }
    return false;
  }

  /// Resetea el formulario a su estado inicial
  void resetForm() {
    formKey.currentState?.reset();
  }

  /// Limpia los errores de validación sin resetear los valores
  void clearValidation() {
    formKey.currentState?.validate();
  }
}
