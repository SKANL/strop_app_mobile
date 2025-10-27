// lib/src/core/core_ui/widgets/scaffolds/form_scaffold.dart
import 'package:flutter/material.dart';
import '../forms/form_action_buttons.dart';

/// Scaffold especializado para pantallas de formularios.
///
/// Elimina ~80 líneas de código repetido en 8+ screens de formularios.
/// Proporciona una estructura consistente con scroll, padding y botones de acción.
///
/// **Características**:
/// - ListView con padding estándar
/// - Scroll automático
/// - Botones de acción (Guardar/Cancelar) integrados
/// - Manejo de estado de loading
///
/// **Ejemplo de uso básico**:
/// ```dart
/// FormScaffold(
///   title: 'Nuevo Reporte',
///   formKey: _formKey,
///   onSubmit: _handleSubmit,
///   isLoading: provider.isLoading,
///   children: [
///     FormFieldWithLabel(label: 'Nombre', ...),
///     FormFieldWithLabel(label: 'Descripción', ...),
///   ],
/// )
/// ```
///
/// **Con secciones**:
/// ```dart
/// FormScaffold(
///   title: 'Editar Perfil',
///   formKey: _formKey,
///   onSubmit: _save,
///   sections: [
///     FormSection(title: 'Datos Personales', children: [...]),
///     FormSection(title: 'Contacto', children: [...]),
///   ],
/// )
/// ```
class FormScaffold extends StatelessWidget {
  /// Título del AppBar
  final String title;

  /// Key del formulario para validación
  final GlobalKey<FormState> formKey;

  /// Callback cuando se presiona el botón de submit
  final VoidCallback onSubmit;

  /// Si el formulario está en proceso de guardado
  final bool isLoading;

  /// Lista de widgets children (campos del formulario)
  /// Se ignora si se proporcionan sections
  final List<Widget>? children;

  /// Lista de secciones del formulario (FormSection widgets)
  /// Tiene prioridad sobre children
  final List<Widget>? sections;

  /// Texto del botón de submit (por defecto "Guardar")
  final String? submitText;

  /// Icono del botón de submit
  final IconData? submitIcon;

  /// Si mostrar el botón de cancelar
  final bool showCancelButton;

  /// Callback cuando se presiona cancelar (por defecto hace pop)
  final VoidCallback? onCancel;

  /// Padding del contenido (por defecto 24.0)
  final EdgeInsets? padding;

  /// Acciones adicionales en el AppBar
  final List<Widget>? actions;

  /// Widget adicional antes de los botones de acción
  final Widget? beforeActions;

  const FormScaffold({
    super.key,
    required this.title,
    required this.formKey,
    required this.onSubmit,
    this.isLoading = false,
    this.children,
    this.sections,
    this.submitText,
    this.submitIcon,
    this.showCancelButton = true,
    this.onCancel,
    this.padding,
    this.actions,
    this.beforeActions,
  }) : assert(
          children != null || sections != null,
          'Debe proporcionar children o sections',
        );

  @override
  Widget build(BuildContext context) {
    // Determinar qué contenido mostrar
    final List<Widget> formContent = sections ?? children ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: padding ?? const EdgeInsets.all(24.0),
          children: [
            ...formContent,
            if (beforeActions != null) ...[
              const SizedBox(height: 24),
              beforeActions!,
            ],
            const SizedBox(height: 32),
            FormActionButtons(
              submitText: submitText ?? 'Guardar',
              submitIcon: submitIcon,
              onSubmit: () {
                // Validate form before submitting
                final valid = formKey.currentState?.validate() ?? false;
                if (valid) {
                  onSubmit();
                }
              },
              onCancel: showCancelButton
                  ? (onCancel ?? () => Navigator.of(context).pop())
                  : null,
              isLoading: isLoading,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
