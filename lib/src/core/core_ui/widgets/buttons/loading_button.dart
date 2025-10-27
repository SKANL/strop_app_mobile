import 'package:flutter/material.dart';

/// Widget de botón con estados visuales automáticos.
/// 
/// Maneja 4 estados diferentes con feedback visual:
/// - idle: Estado normal
/// - loading: Muestra CircularProgressIndicator
/// - success: Muestra checkmark brevemente (opcional)
/// - error: Muestra error brevemente (opcional)
/// 
/// Ejemplo de uso:
/// ```dart
/// LoadingButton(
///   text: 'Guardar',
///   icon: Icons.save,
///   onPressed: () async {
///     await saveData();
///   },
/// )
/// 
/// // Con control manual de estado
/// LoadingButton(
///   text: 'Enviar',
///   state: _buttonState,
///   onPressed: () => handleSubmit(),
/// )
/// 
/// // Variante outlined
/// LoadingButton.outlined(
///   text: 'Procesar',
///   icon: Icons.play_arrow,
///   onPressed: () async {
///     await processData();
///   },
/// )
/// ```
class LoadingButton extends StatefulWidget {
  const LoadingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
        this.state = LoadingButtonState.idle,
        this.variant = LoadingButtonVariant.elevated,
    this.size = LoadingButtonSize.medium,
    this.showSuccessState = true,
    this.successDuration = const Duration(seconds: 2),
  });

  final String text;
  final Future<void> Function()? onPressed;
  final IconData? icon;
  final LoadingButtonState state;
  final LoadingButtonVariant variant;
  final LoadingButtonSize size;
  final bool showSuccessState;
  final Duration successDuration;

  /// Constructor para botón outlined.
  const LoadingButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.state = LoadingButtonState.idle,
    this.size = LoadingButtonSize.medium,
    this.showSuccessState = true,
    this.successDuration = const Duration(seconds: 2),
  }) : variant = LoadingButtonVariant.outlined;

  /// Constructor para botón de texto.
  const LoadingButton.text({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.state = LoadingButtonState.idle,
    this.size = LoadingButtonSize.medium,
    this.showSuccessState = true,
    this.successDuration = const Duration(seconds: 2),
  }) : variant = LoadingButtonVariant.text;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  LoadingButtonState _internalState = LoadingButtonState.idle;

  LoadingButtonState get effectiveState =>
      widget.state != LoadingButtonState.idle ? widget.state : _internalState;

  Future<void> _handlePressed() async {
    if (widget.onPressed == null) return;
    if (effectiveState != LoadingButtonState.idle) return;

    setState(() {
      _internalState = LoadingButtonState.loading;
    });

    try {
      await widget.onPressed!();

      if (widget.showSuccessState && mounted) {
        setState(() {
          _internalState = LoadingButtonState.success;
        });

        await Future.delayed(widget.successDuration);

        if (mounted) {
          setState(() {
            _internalState = LoadingButtonState.idle;
          });
        }
      } else if (mounted) {
        setState(() {
          _internalState = LoadingButtonState.idle;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _internalState = LoadingButtonState.error;
        });

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          setState(() {
            _internalState = LoadingButtonState.idle;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = widget.onPressed == null;
    final currentState = effectiveState;

    // Determinar contenido del botón según estado
    Widget content;
    switch (currentState) {
      case LoadingButtonState.idle:
        content = _buildIdleContent();
        break;
      case LoadingButtonState.loading:
        content = _buildLoadingContent();
        break;
      case LoadingButtonState.success:
        content = _buildSuccessContent();
        break;
      case LoadingButtonState.error:
        content = _buildErrorContent();
        break;
    }

    // Determinar tamaño
    final padding = _getPadding();
    final height = _getHeight();

    // Construir botón según variante
    switch (widget.variant) {
      case LoadingButtonVariant.elevated:
        return SizedBox(
          height: height,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isDisabled || currentState != LoadingButtonState.idle
                ? null
                : _handlePressed,
            style: ElevatedButton.styleFrom(
              padding: padding,
              backgroundColor: _getBackgroundColor(currentState, theme),
            ),
            child: content,
          ),
        );
      case LoadingButtonVariant.outlined:
        return SizedBox(
          height: height,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isDisabled || currentState != LoadingButtonState.idle
                ? null
                : _handlePressed,
            style: OutlinedButton.styleFrom(
              padding: padding,
              side: BorderSide(color: _getBorderColor(currentState, theme)),
            ),
            child: content,
          ),
        );
      case LoadingButtonVariant.text:
        return SizedBox(
          height: height,
          child: TextButton(
            onPressed: isDisabled || currentState != LoadingButtonState.idle
                ? null
                : _handlePressed,
            style: TextButton.styleFrom(
              padding: padding,
            ),
            child: content,
          ),
        );
    }
  }

  Widget _buildIdleContent() {
    if (widget.icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, size: _getIconSize()),
          const SizedBox(width: 8),
          Text(widget.text, style: _getTextStyle()),
        ],
      );
    }
    return Text(widget.text, style: _getTextStyle());
  }

  Widget _buildLoadingContent() {
    return SizedBox(
      height: _getIconSize(),
      width: _getIconSize(),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.variant == LoadingButtonVariant.elevated
              ? Colors.white
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: _getIconSize(), color: Colors.green),
        const SizedBox(width: 8),
        Text('Completado', style: _getTextStyle()),
      ],
    );
  }

  Widget _buildErrorContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, size: _getIconSize(), color: Colors.red),
        const SizedBox(width: 8),
        Text('Error', style: _getTextStyle()),
      ],
    );
  }

  Color? _getBackgroundColor(LoadingButtonState state, ThemeData theme) {
    switch (state) {
      case LoadingButtonState.success:
        return Colors.green;
      case LoadingButtonState.error:
        return Colors.red;
      default:
        return null;
    }
  }

  Color _getBorderColor(LoadingButtonState state, ThemeData theme) {
    switch (state) {
      case LoadingButtonState.success:
        return Colors.green;
      case LoadingButtonState.error:
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (widget.size) {
      case LoadingButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case LoadingButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case LoadingButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case LoadingButtonSize.small:
        return 36;
      case LoadingButtonSize.medium:
        return 48;
      case LoadingButtonSize.large:
        return 56;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case LoadingButtonSize.small:
        return 16;
      case LoadingButtonSize.medium:
        return 20;
      case LoadingButtonSize.large:
        return 24;
    }
  }

  TextStyle? _getTextStyle() {
    final theme = Theme.of(context);
    switch (widget.size) {
      case LoadingButtonSize.small:
        return theme.textTheme.bodyMedium;
      case LoadingButtonSize.medium:
        return theme.textTheme.bodyLarge;
      case LoadingButtonSize.large:
        return theme.textTheme.titleMedium;
    }
  }
}

enum LoadingButtonState {
  idle,
  loading,
  success,
  error,
}

enum LoadingButtonSize {
  small,
  medium,
  large,
}

/// Variante visual del LoadingButton
enum LoadingButtonVariant {
  elevated,
  outlined,
  text,
}
