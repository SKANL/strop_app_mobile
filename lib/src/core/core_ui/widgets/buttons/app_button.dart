// lib/src/core/core_ui/widgets/buttons/app_button.dart

import 'package:flutter/material.dart';

/// Widget reutilizable para botones con variantes y estados consistentes.
///
/// Elimina la duplicación de ~23 botones en la app con estilos inconsistentes.
/// Maneja estados de loading, disabled, y diferentes variantes de estilo.
///
/// **Usado en**: Todos los screens con formularios, diálogos, acciones
///
/// **Ejemplo básico**:
/// ```dart
/// AppButton.primary(
///   text: 'Guardar',
///   onPressed: () => save(),
///   icon: Icons.save,
/// )
/// ```
///
/// **Con loading state**:
/// ```dart
/// AppButton.primary(
///   text: 'Guardar',
///   isLoading: _isLoading,
///   onPressed: _handleSubmit,
/// )
/// ```
///
/// **Botón de peligro**:
/// ```dart
/// AppButton.danger(
///   text: 'Eliminar',
///   icon: Icons.delete,
///   onPressed: () => _confirmDelete(context),
/// )
/// ```
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final ButtonVariant variant;
  final ButtonSize size;
  final Color? customColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.customColor,
  });

  /// Constructor para botón principal (ElevatedButton azul)
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.medium,
  })  : variant = ButtonVariant.primary,
        customColor = null;

  /// Constructor para botón secundario (FilledButton gris)
  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.medium,
  })  : variant = ButtonVariant.secondary,
        customColor = null;

  /// Constructor para botón con borde (OutlinedButton)
  const AppButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.medium,
    this.customColor,
  })  : variant = ButtonVariant.outlined;

  /// Constructor para botón de texto (TextButton)
  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.medium,
  })  : variant = ButtonVariant.text,
        customColor = null;

  /// Constructor para acciones peligrosas (OutlinedButton rojo)
  const AppButton.danger({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.medium,
  })  : variant = ButtonVariant.outlined,
        customColor = Colors.red;

  /// Constructor para botones de éxito (ElevatedButton verde)
  const AppButton.success({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.size = ButtonSize.medium,
  })  : variant = ButtonVariant.primary,
        customColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    // Si está cargando, mostrar spinner en lugar del texto
    if (isLoading) {
      return _buildLoadingButton(context);
    }

    return switch (variant) {
      ButtonVariant.primary => _buildElevatedButton(context),
      ButtonVariant.secondary => _buildFilledButton(context),
      ButtonVariant.outlined => _buildOutlinedButton(context),
      ButtonVariant.text => _buildTextButton(context),
    };
  }

  Widget _buildLoadingButton(BuildContext context) {
    // Botón deshabilitado con spinner
    final spinner = SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          variant == ButtonVariant.outlined || variant == ButtonVariant.text
              ? Theme.of(context).colorScheme.primary
              : Colors.white,
        ),
      ),
    );

    return switch (variant) {
      ButtonVariant.primary => ElevatedButton(
          onPressed: null,
          style: _getButtonStyle(context),
          child: spinner,
        ),
      ButtonVariant.secondary => FilledButton(
          onPressed: null,
          style: _getButtonStyle(context),
          child: spinner,
        ),
      ButtonVariant.outlined => OutlinedButton(
          onPressed: null,
          style: _getButtonStyle(context),
          child: spinner,
        ),
      ButtonVariant.text => TextButton(
          onPressed: null,
          style: _getButtonStyle(context),
          child: spinner,
        ),
    };
  }

  Widget _buildElevatedButton(BuildContext context) {
    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: _getButtonStyle(context),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: _getButtonStyle(context),
      child: Text(text),
    );
  }

  Widget _buildFilledButton(BuildContext context) {
    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: _getButtonStyle(context),
      );
    }

    return FilledButton(
      onPressed: onPressed,
      style: _getButtonStyle(context),
      child: Text(text),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: _getButtonStyle(context),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: _getButtonStyle(context),
      child: Text(text),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    if (icon != null) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: _getButtonStyle(context),
      );
    }

    return TextButton(
      onPressed: onPressed,
      style: _getButtonStyle(context),
      child: Text(text),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final baseStyle = switch (variant) {
      ButtonVariant.primary => ElevatedButton.styleFrom(
          backgroundColor: customColor,
          minimumSize: size.minimumSize,
          padding: size.padding,
        ),
      ButtonVariant.secondary => FilledButton.styleFrom(
          backgroundColor: customColor,
          minimumSize: size.minimumSize,
          padding: size.padding,
        ),
      ButtonVariant.outlined => OutlinedButton.styleFrom(
          foregroundColor: customColor,
          minimumSize: size.minimumSize,
          padding: size.padding,
          side: customColor != null
              ? BorderSide(color: customColor!)
              : null,
        ),
      ButtonVariant.text => TextButton.styleFrom(
          minimumSize: size.minimumSize,
          padding: size.padding,
        ),
    };

    return baseStyle;
  }
}

/// Variantes de estilo del botón
enum ButtonVariant {
  /// Botón elevado con color de fondo (ElevatedButton)
  primary,

  /// Botón relleno sin elevación (FilledButton)
  secondary,

  /// Botón con borde sin relleno (OutlinedButton)
  outlined,

  /// Botón de solo texto (TextButton)
  text,
}

/// Tamaños predefinidos del botón
enum ButtonSize {
  /// Botón pequeño (altura: 36px)
  small(
    Size(120, 36),
    EdgeInsets.symmetric(horizontal: 12),
  ),

  /// Botón mediano (altura: 48px, ancho completo)
  medium(
    Size(double.infinity, 48),
    EdgeInsets.symmetric(horizontal: 16),
  ),

  /// Botón grande (altura: 56px, ancho completo)
  large(
    Size(double.infinity, 56),
    EdgeInsets.symmetric(horizontal: 20),
  ),

  /// Botón compacto (solo envuelve contenido)
  compact(
    Size(100, 40),
    EdgeInsets.symmetric(horizontal: 16),
  );

  const ButtonSize(this.minimumSize, this.padding);

  /// Tamaño mínimo del botón
  final Size minimumSize;

  /// Padding interno del botón
  final EdgeInsets padding;
}

// =============================================================================
// EJEMPLOS DE USO EN LA APP
// =============================================================================

/// Ejemplos de cómo usar AppButton en diferentes contextos
class _AppButtonExamples extends StatelessWidget {
  const _AppButtonExamples();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Ejemplo 1: Botón principal
        AppButton.primary(
          text: 'Guardar Cambios',
          icon: Icons.save,
          onPressed: () {},
        ),
        
        const SizedBox(height: 16),

        // Ejemplo 2: Botón con loading
        AppButton.primary(
          text: 'Enviando...',
          isLoading: true,
          onPressed: null,
        ),

        const SizedBox(height: 16),

        // Ejemplo 3: Botón de peligro
        AppButton.danger(
          text: 'Cerrar Sesión',
          icon: Icons.logout,
          onPressed: () {},
        ),

        const SizedBox(height: 16),

        // Ejemplo 4: Botón outlined
        AppButton.outlined(
          text: 'Cancelar',
          onPressed: () {},
        ),

        const SizedBox(height: 16),

        // Ejemplo 5: Botón de texto
        AppButton.text(
          text: 'Ver Más',
          icon: Icons.arrow_forward,
          onPressed: () {},
        ),

        const SizedBox(height: 16),

        // Ejemplo 6: Botón pequeño
        AppButton.primary(
          text: 'OK',
          size: ButtonSize.small,
          onPressed: () {},
        ),

        const SizedBox(height: 16),

        // Ejemplo 7: Botón de éxito
        AppButton.success(
          text: 'Aprobar',
          icon: Icons.check,
          onPressed: () {},
        ),

        const SizedBox(height: 16),

        // Ejemplo 8: Fila de acciones en diálogo
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton.text(
              text: 'Cancelar',
              size: ButtonSize.compact,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 8),
            AppButton.primary(
              text: 'Confirmar',
              size: ButtonSize.compact,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
